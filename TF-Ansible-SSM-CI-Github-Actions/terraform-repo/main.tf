data "aws_ami" "al2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_iam_policy_document" "ec2_trust" {
  statement { actions = ["sts:AssumeRole"]; principals { type = "Service"; identifiers = ["ec2.amazonaws.com"] } }
}

resource "aws_iam_role" "ssm_role" { name = "ec2-ssm-role"; assume_role_policy = data.aws_iam_policy_document.ec2_trust.json }
resource "aws_iam_role_policy_attachment" "ssm_core" { role = aws_iam_role.ssm_role.name; policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" }
resource "aws_iam_instance_profile" "ssm_profile" { name = "ec2-ssm-profile"; role = aws_iam_role.ssm_role.name }

resource "aws_instance" "web" {
  count                  = var.instance_count
  ami                    = data.aws_ami.al2.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  key_name               = var.key_name
  tags = {
    Name    = "${var.name_prefix}-${count.index + 1}"
    Project = var.project
    Env     = var.env
    Role    = "web"
    Ansible = var.ansible_enabled ? "true" : "false"
  }
}
