resource "aws_ssm_parameter" "jenkins-admin-user" {
  name  = "jenkins-admin-user"
  type  = "String"
  value = "${var.jenkins_admin_user}"
}

resource "aws_ssm_parameter" "jenkins-admin-pass" {
  name  = "jenkins-admin-pass"
  type  = "SecureString"
  value = "${var.jenkins_admin_pass}"
}

resource "aws_ssm_parameter" "jenkins-build-user" {
  name  = "jenkins-build-user"
  type  = "String"
  value = "${var.jenkins_build_user}"
}

resource "aws_ssm_parameter" "jenkins-build-pass" {
  name  = "jenkins-build-pass"
  type  = "SecureString"
  value = "${var.jenkins_build_pass}"
}

resource "aws_ssm_parameter" "jenkins-read-user" {
  name  = "jenkins-read-user"
  type  = "String"
  value = "${var.jenkins_read_user}"
}

resource "aws_ssm_parameter" "jenkins-read-pass" {
  name  = "jenkins-read-pass"
  type  = "SecureString"
  value = "${var.jenkins_read_pass}"
}

resource "aws_ssm_parameter" "jenkins-github-user" {
  name  = "jenkins-github-user"
  type  = "String"
  value = "${var.jenkins_github_user}"
}

resource "aws_ssm_parameter" "jenkins-github-key" {
  name  = "jenkins-github-key"
  type  = "SecureString"
  value = "${var.jenkins_github_key}"
}