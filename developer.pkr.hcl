source "vmware-iso" "developer-workstation" {
  format = "ovf"
  iso_urls = [
    "iso/rhel-server-7.9-x86_64-dvd.iso",
    "https://access.cdn.redhat.com/content/origin/files/sha256/19/19d653ce2f04f202e79773a0cbeda82070e7527557e814ebbce658773fbe8191/rhel-server-7.9-x86_64-dvd.iso?_auth_=1616007932_6809ab265f4205b100d77eb72c8d48a9"
  ]
  iso_checksum = "sha256:19d653ce2f04f202e79773a0cbeda82070e7527557e814ebbce658773fbe8191"
  boot_wait = "10s"
  boot_command = [
    "<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"
  ]
  headless = true
  guest_os_type = "rhel7-64"
  http_directory = "http"
  ssh_username = var.system_user
  ssh_password = var.system_pass
  ssh_wait_timeout = "10000s"
  shutdown_command = "echo '${var.system_pass}'|sudo -S /sbin/halt -h -p"
  tools_upload_flavor = "linux"
}

build {
  sources = ["sources.vmware-iso.developer-workstation"]
  provisioner "shell" {
    environment_vars = [
      "RHSM_USERNAME=${var.rhsm_user}",
      "RHSM_PASSWORD=${var.rhsm_pass}",
      "RHSM_POOL=${var.rhsm_pool}"
    ]
    execute_command = "echo '${var.system_pass}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    script = "scripts/ansible.sh"
  }
  provisioner "ansible-local" {
    playbook_dir = "./ansible"
    playbook_file = "./ansible/playbook.yml"
  }
  provisioner "shell" {
    execute_command = "echo '${var.system_pass}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    script = "scripts/cleanup.sh"
  }
}