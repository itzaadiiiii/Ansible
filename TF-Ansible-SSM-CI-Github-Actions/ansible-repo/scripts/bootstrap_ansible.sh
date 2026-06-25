#!/usr/bin/env bash
set -euo pipefail
if [ ! -d ".venv" ]; then
  python3 -m venv .venv
fi
source .venv/bin/activate
pip install --upgrade pip
pip install "ansible-core>=2.16" boto3 botocore
ansible-galaxy collection install -r requirements.yml
echo "✅ Ansible ready. Activate with: source .venv/bin/activate"
ansible --version
