#!/usr/bin/env bash
set -euo pipefail
: "${AWS_REGION:=ap-south-1}"
source .venv/bin/activate
ansible-inventory --graph
LIMIT="${1:-project_Slash:&env_Dev}"
ansible-playbook playbooks/site.yml -l "$LIMIT"
