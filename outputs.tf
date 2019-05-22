data "aws_route53_zone" "selected" {
  name         = "dcleric.xyz."
  private_zone = false
  provider = "aws.us"
  }