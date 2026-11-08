# EC2 trust policy
data "aws_iam_policy_document" "bastion_ssm_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

# IAM role for Bastion EC2
resource "aws_iam_role" "bastion_ssm" {
  name               = "${var.environment}-bastion-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.bastion_ssm_assume_role.json

  tags = local.common_tags
}

# Attach AWS-managed SSM policy
resource "aws_iam_role_policy_attachment" "bastion_ssm" {
  role       = aws_iam_role.bastion_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile for EC2
resource "aws_iam_instance_profile" "bastion_ssm" {
  name = "${var.environment}-bastion-ssm-profile"
  role = aws_iam_role.bastion_ssm.name

  tags = local.common_tags
}