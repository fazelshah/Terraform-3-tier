resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = [for subnet in aws_subnet.pub : subnet.id]

  enable_deletion_protection = true

 
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.bqe.id
}

resource "aws_lb_listener" "all" {
    load_balancer_arn = aws_lb.test.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "fixed-response"

      fixed_response {
        content_type = "text/plain"
        message_body = "fixed response content"
        status_code = "200"
      }
    }
  
}
resource "aws_lb_listener_rule" "rule" {
    listener_arn = aws_lb_listener.all.arn
    priority = 100

    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.test.arn

    }
  condition {
    path_pattern {
      values = ["/static/*"]
    }
  }
  condition {
    host_header {
      values = ["exapmles.com"]
    }
  }
}