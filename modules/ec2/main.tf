data "aws_subnet" "REDACTED" {
  id = "REDACTED"
}

resource "aws_instance" "host" {
  ami           = coalesce(var.ami, "AMI_ID")
  instance_type = var.instance_type

  iam_instance_profile = var.iam_instance_profile
  key_name             = "IAM_INSTANCE_PROFILE"
  tags = {
    Name              = var.hostname
    Application       = var.application
    Environment       = var.Env
    Logical_Component = var.logical_component
    Service_Component = var.service_component
    Service           = var.service
  }
  vpc_security_group_ids = var.security_groups
  subnet_id              = coalesce(var.subnet, data.aws_subnet.REDACTED.id)
  # Required for PaC scanning
  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    kms_key_id            = null

    throughput  = 125
    volume_size = var.root_size
    volume_type = "gp3"
  }

  volume_tags = {
    Application = "var.application"
    Environment = var.Env
  }
  lifecycle {
    # Changes to AMI will not delete existing infrastructure
    ignore_changes = [ami]
  }
}
