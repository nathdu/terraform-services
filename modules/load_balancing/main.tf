resource "aws_lb" "load_balancer" {
  name               = "services-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.public_subnets

}

resource "aws_lb_target_group" "services_target_group" {
  count       = length(var.service_names)
  name        = "${var.service_names[count.index]}-target-group"
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path     = "/api/${var.service_names[count.index]}/health"
    protocol = "HTTP"
    port     = 3000
  }
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  count            = length(var.service_names)
  target_group_arn = aws_lb_target_group.services_target_group[count.index].arn
  target_id        = var.server_ids[count.index]
  port             = 3000
}

resource "aws_lb_listener" "load_balancer_listener" {
  count             = length(var.service_names)
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 3000 + count.index
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.services_target_group[count.index].arn
  }
}