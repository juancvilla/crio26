sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
sudo setenforce 0
echo "sudo vi /etc/hosts"
echo "10.128.15.228 master-node-k8          // For the Master node"
echo "10.128.15.230 worker-node-1-k8        // For the Worker node"
mkdir -p ~/k8sInstall
cd ~/k8sInstall
sudo yum localinstall -y iproute-tc-5.18.0-1.el8.x86_64.rpm
sudo systemctl stop firewalld
sudo systemctl disable firewalld
echo "On Master node, allow following ports,
$ sudo firewall-cmd --permanent --add-port=6443/tcp
$ sudo firewall-cmd --permanent --add-port=2379-2380/tcp
$ sudo firewall-cmd --permanent --add-port=10250/tcp
$ sudo firewall-cmd --permanent --add-port=10251/tcp
$ sudo firewall-cmd --permanent --add-port=10252/tcp
$ sudo firewall-cmd --reload"
echo "On Worker node, allow following ports,
$ sudo firewall-cmd --permanent --add-port=10250/tcp
$ sudo firewall-cmd --permanent --add-port=30000-32767/tcp
$ sudo firewall-cmd --reload"

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --syste
export VERSION=1.26
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/devel:kubic:libcontainers:stable.repo
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/CentOS_8/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo
cd ~/k8sInstall
sudo yum -y localinstall conntrack-tools-1.4.4-10.el8.x86_64.rpm libnetfilter_conntrack-1.0.6-5.el8.x86_64.rpm libnetfilter_cthelper-1.0.0-15.el8.x86_64.rpm libnetfilter_cttimeout-1.0.0-11.el8.x86_64.rpm libnetfilter_queue-1.0.4-3.el8.x86_64.rpm
sudo yum -y localinstall socat-1.7.4.1-1.el8.x86_64.rpm
sudo dnf -y install cri-o
sudo systemctl enable crio
sudo systemctl start crio
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
sudo dnf install -y kubelet-1.26.1 kubeadm-1.26.1 kubectl-1.26.1 --disableexcludes=kubernetes




