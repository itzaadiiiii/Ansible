# Terraform + Ansible with GitHub Actions Dispatch

This bundle contains two separate repositories and CI workflows that demonstrate a modern SSH-less flow:

- `terraform-repo/` — Terraform code to create EC2 instances with SSM enabled and tags.
- `ansible-repo/` — Ansible playbook + dynamic inventory; workflow listens for repository_dispatch to run playbooks.

Default AWS region: **ap-south-1** (Mumbai). Default AMI: Amazon Linux 2 (most recent).

---

## What I created
- Terraform code that provisions instances and tags them: `terraform-repo/`
- GitHub Actions in Terraform repo that runs `terraform apply` on push and triggers a `repository_dispatch` event against the Ansible repo.
- Ansible repo that runs the playbook when it receives the `run-ansible` repository_dispatch event.
- README instructions below for secrets and PAT setup.

---

## Quick usage (local)

1. Clone and push each folder into separate GitHub repositories (see steps below).
2. In Terraform repo: edit `terraform.tfvars`, run `terraform init` and `terraform apply` locally OR push to GitHub main to trigger the workflow.
3. Ensure Ansible repo secrets are set (see next section). When Terraform workflow finishes it will dispatch to Ansible repo to run playbook.

---

## GitHub Actions and secrets setup (required)

### In Terraform repo (on GitHub)
Set these repository secrets:
- `AWS_ACCESS_KEY_ID` (for terraform apply in workflow)
- `AWS_SECRET_ACCESS_KEY`
- `ANSIBLE_REPO_PAT` — a GitHub Personal Access Token with `repo` scope (for private repos) or minimal scopes to allow repository_dispatch.
- `ANSIBLE_REPO` — owner/repo of the Ansible repository, e.g. `myorg/ansible-repo`

**Why:** the Terraform workflow uses `ANSIBLE_REPO_PAT` to POST the `repository_dispatch` event into the target repo.

### In Ansible repo (on GitHub)
Set these repository secrets:
- `AWS_ACCESS_KEY_ID` (for Ansible run)
- `AWS_SECRET_ACCESS_KEY`

**Why:** the Ansible workflow needs AWS credentials to reach EC2/SSM during the playbook run.

---

## How the dispatch works (brief)
1. Push to Terraform repo `main` → workflow runs `terraform apply` (uses AWS creds from TF repo secrets).
2. On success, workflow calls GitHub API with `ANSIBLE_REPO_PAT` and posts `repository_dispatch` to the `ANSIBLE_REPO` with event type `run-ansible`.
3. Ansible repo receives the repository_dispatch event and triggers its workflow which checks out code, installs Python/Ansible, and runs the playbook using AWS creds from Ansible repo secrets.

---

## Security notes
- Store credentials and PAT in GitHub repository secrets, not in code.
- Limit PAT scopes to minimum required for `repository_dispatch` (repo scope might be required for private repos).
- Prefer using organization or machine accounts for automation rather than personal PATs.
# TF-Ansible-SSM-CI-Github-Actions
