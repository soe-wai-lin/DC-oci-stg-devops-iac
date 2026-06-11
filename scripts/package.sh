#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/package-bootstrap.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "=== bootstrap started: $(date) ==="

# Ensure yum vars directory exists
mkdir -p /etc/yum/vars

# Fix malformed OCI yum variable expansion.
# If the OCI repo variables are empty, fall back to public yum.oracle.com.
if [ ! -s /etc/yum/vars/ocidomain ]; then
  echo "oracle.com" > /etc/yum/vars/ocidomain
fi

if [ ! -f /etc/yum/vars/ociregion ]; then
  : > /etc/yum/vars/ociregion
fi

# If using public yum fallback, disable OCI-only / restricted repos
for repo in /etc/yum.repos.d/ksplice-ol9.repo /etc/yum.repos.d/oci-included-ol9.repo; do
  if [ -f "$repo" ]; then
    sed -i 's/^enabled *= *1/enabled=0/g' "$repo"
  fi
done

# Refresh metadata
dnf clean all
rm -rf /var/cache/dnf
dnf -y makecache

# Base tools
sudo dnf -y install dnf-utils git zip unzip

# Remove packages that can conflict with Docker on OL8/OL9
sudo dnf -y remove podman buildah runc || true
sudo dnf -y module disable container-tools || true

# Add Docker CE repo
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker Engine + Compose plugin
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start Docker
sudo systemctl enable --now docker

# Optional: allow opc user to run docker without sudo
sudo usermod -aG docker opc || true

# Verification
git --version || true
docker --version || true
docker compose version || true
systemctl status docker --no-pager || true

echo "=== bootstrap finished: $(date) ==="


# ------------------------------------------------------------------------------
# Create folder for your monitoring stack
# ------------------------------------------------------------------------------
mkdir -p /monitoring/grafana-data

# Grafana container usually expects writable storage
chown -R 472:472 /monitoring/grafana-data || true

# ------------------------------------------------------------------------------
# Write docker-compose.yml
# ------------------------------------------------------------------------------
cat > /monitoring/docker-compose.yml <<'EOF'
services:
  grafana:
    image: grafana/grafana
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      GF_SECURITY_ADMIN_PASSWORD: grafana
    volumes:
      - /monitoring/grafana-data:/var/lib/grafana
    restart: always
    networks:
      - monitoring

networks:
  monitoring:
EOF


# ------------------------------------------------------------------------------
# Start the stack
# ------------------------------------------------------------------------------
cd /monitoring
docker compose up -d
docker compose ps
