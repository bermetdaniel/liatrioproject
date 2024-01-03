resource "aws_ecr_repository" "jenkins-master-repo" {
  name                 = "${var.jenkins_master_repo}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "app-repo" {
  name                 = "${var.app_repo}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = false
  }
}