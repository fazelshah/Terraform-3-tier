


resource "aws_launch_configuration" "launch" {
    name = "Temp-image"
image_id =  "ami-0a52ec36f8c5ad6d5"
 instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "asg" {
    name = "ASG"
 launch_configuration = aws_launch_configuration.launch.name 
  availability_zones = ["ap-south-1a"]
  desired_capacity   = 1
 min_size = 1
 max_size = 2

}
resource "aws_autoscaling_attachment" "attach" {
    autoscaling_group_name = aws_autoscaling_group.asg.id
    lb_target_group_arn = aws_lb_target_group.tg.arn
  
}

