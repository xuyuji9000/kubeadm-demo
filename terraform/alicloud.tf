provider "alicloud" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

resource "alicloud_key_pair" "key_pair" {
    key_name = "${var.key_name}"
    key_file = "${var.key_file}"
}

resource "alicloud_instance" "web" {
    availability_zone          = "${var.availability_zone}"
    image_id                   = "m-t4nj36enzsqshlf2h267"
                                  
    internet_charge_type       = "PayByTraffic"
    internet_max_bandwidth_out = "100"
    allocate_public_ip         = true
    
    instance_type              = "ecs.e3.small"
    is_outdated                = true
    system_disk_category       = "cloud_efficiency"
    instance_name              = "web"
    
    key_name                   = "${alicloud_key_pair.key_pair.id}"

    security_groups            = ["${alicloud_security_group.default.id}"]
    vswitch_id                 = "${alicloud_vswitch.terraform_switch.id}"
}

output "ip" {
    value = "${alicloud_instance.web.public_ip}"
}

resource "alicloud_security_group" "default" {
    name        = "default"
    description = "default"
    vpc_id      = "${alicloud_vpc.terraform_vpc.id}"
}

resource "alicloud_security_group_rule" "ping" {
    type              = "ingress"
    ip_protocol       = "icmp"
    policy            = "accept"
    priority          = 1
    port_range        = "-1/-1"
    security_group_id = "${alicloud_security_group.default.id}"
    cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "ssh" {
    type              = "ingress"
    ip_protocol       = "tcp"
    port_range        = "22/22"
    policy            = "accept"
    priority          = 1
    security_group_id = "${alicloud_security_group.default.id}"
    cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "kubernetes_api_server" {
    type              = "ingress"
    ip_protocol       = "tcp"
    port_range        = "6443/6443"
    policy            = "accept"
    priority          = 1
    security_group_id = "${alicloud_security_group.default.id}"
    cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "etcd" {
    type              = "ingress"
    ip_protocol       = "tcp"
    port_range        = "2379/2380"
    policy            = "accept"
    priority          = 1
    security_group_id = "${alicloud_security_group.default.id}"
    cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "kubelet" {
    type              = "ingress"
    ip_protocol       = "tcp"
    port_range        = "10250/10250"
    policy            = "accept"
    priority          = 1
    security_group_id = "${alicloud_security_group.default.id}"
    cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "kube-scheduler" {
    type              = "ingress"
    ip_protocol       = "tcp"
    port_range        = "10251/10251"
    policy            = "accept"
    priority          = 1
    security_group_id = "${alicloud_security_group.default.id}"
    cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "kube-controller-manager" {
    type              = "ingress"
    ip_protocol       = "tcp"
    port_range        = "10252/10252"
    policy            = "accept"
    priority          = 1
    security_group_id = "${alicloud_security_group.default.id}"
    cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "heapster" {
    type              = "ingress"
    ip_protocol       = "tcp"
    port_range        = "10255/10255"
    policy            = "accept"
    priority          = 1
    security_group_id = "${alicloud_security_group.default.id}"
    cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "web-1" {
    type              = "ingress"
    ip_protocol       = "tcp"
    port_range        = "80/80"
    policy            = "accept"
    priority          = 1
    security_group_id = "${alicloud_security_group.default.id}"
    cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "web-2" {
    type              = "ingress"
    ip_protocol       = "tcp"
    port_range        = "8080/8080"
    policy            = "accept"
    priority          = 1
    security_group_id = "${alicloud_security_group.default.id}"
    cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_vpc" "terraform_vpc" {
    name       = "terraform_vpc"
    cidr_block = "172.16.0.0/12"
}

resource "alicloud_vswitch" "terraform_switch" {
    vpc_id            = "${alicloud_vpc.terraform_vpc.id}"
    cidr_block        = "172.16.0.0/16"
    availability_zone = "${var.availability_zone}"
}