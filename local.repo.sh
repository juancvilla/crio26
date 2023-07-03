cat <<EOF | sudo tee /etc/yum.repos.d/local.repo
[local]
name=local
baseurl=file:///mnt/BaseOS/
enabled=1
gpgcheck=0
EOF
