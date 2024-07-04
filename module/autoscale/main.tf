resource "aws_launch_configuration" "val_launch_config" {
  name          = "${var.environment}-launch-configuration-${var.date}"
  image_id      = var.ami_id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "val_autoscale" {
  
  desired_capacity     = var.desired_capacity_AC[var.environment].desired_capacity
  max_size             = var.desired_capacity_AC[var.environment].max_size
  min_size             = var.desired_capacity_AC[var.environment].min_size
  launch_configuration = aws_launch_configuration.val_launch_config.id
  vpc_zone_identifier  = [var.subnet_id]
  //target_group_arns    = var.have_load_balancer ? [aws_lb_target_group.val_lb_target_group[1].target_group_arns] : []
  tag {
    key                 = "valentin_autoscale"
    value               = "${var.environment}-autoscaling-group-${var.date}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "val_lb" {
  count = var.have_load_balancer ? 1 : 0

  name               = "${var.environment}-load-balancer-${var.date}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = aws_security_group.lb_sg.id
  subnets            = aws_subnet.public.id
}

resource "aws_security_group" "lb_sg" {
  name_prefix = "${var.environment}-lb-sg-${var.date}"
  vpc_id      = var.subnet_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "asg_sg" {
  name_prefix = "${var.environment}-asg-sg-${var.date}"
  vpc_id      = var.subnet_id

  ingress {
    from_port        = var.port_number
    to_port          = var.port_number
    protocol         = "tcp"
    security_groups  = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_lb_target_group" "val_lb_target_group" {
  count = var.have_load_balancer ? 1 : 0

  name        = "${var.environment}-target-group-${var.date}"
  port        = var.port_number
  protocol    = "HTTP"
  vpc_id      = var.subnet_id
  target_type = "instance"
}

resource "aws_lb_listener" "example" {
  count = var.have_load_balancer ? 1 : 0

  load_balancer_arn = aws_lb.val_lb[count.index].arn
  port              = var.port_number
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.val_lb_target_group[count.index].arn
  }
}
