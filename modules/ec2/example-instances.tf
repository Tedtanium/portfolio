module "dev-web" {
  source            = "./"
  instance_type     = "m5.xlarge"
  hostname          = "REDACTED"
  logical_component = "REDACTED"
  service           = "REDACTED"
  service_component = "REDACTED"
  security_groups   = [aws_security_group.dev_web.id]
  ebs_size          = 500
  Env               = "REDACTED"

}

resource "aws_alb_target_group_attachment" "dev-web-443" {
  target_group_arn = aws_lb_target_group.dev_web_proxy.arn
  target_id        = module.dev-web.id
  port             = 443
}



module "dev-mqt" {
  source            = "./"
  instance_type     = "m5.large"
  hostname          = "REDACTED"
  logical_component = "REDACTED"
  service           = "REDACTED"
  service_component = "REDACTED"
  security_groups   = [aws_security_group.dev_mqtt.id]
  ebs_size          = 48
  Env               = "REDACTED"
}




module "dev-api" {
  source            = "./"
  instance_type     = "c5n.xlarge"
  hostname          = "REDACTED"
  logical_component = "REDACTED"
  service           = "REDACTED"
  service_component = "REDACTED"
  security_groups   = [aws_security_group.dev_api.id]
  ebs_size          = 48
}


# import {
#   to = module.dev-api.aws_instance.host
#   id = "REDACTED"
# }

# import {
#   to = aws_security_group.dev_web
#   id = "REDACTED"
# }
# import {
#   to = aws_security_group.dev_mqtt
#   id = "REDACTED"
# }

# import {
#   to = aws_security_group.dev_api
#   id = "REDACTED"
# }
