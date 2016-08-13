yum update -y
yum install wget -y
wget -P /etc/yum.repos.d/ https://download.openvz.org/openvz.repo
rpm --import http://download.openvz.org/RPM-GPG-Key-OpenVZ
echo "Openvz Repos Downloaded"
sleep 2
yum install vzkernel -y
echo "Vzkernel Package Installed"
sleep 2

cat >/etc/sysctl.conf <<EOL
# On Hardware Node we generally need
# packet forwarding enabled and proxy arp disabled
net.ipv4.ip_forward = 1
net.ipv6.conf.default.forwarding = 1
net.ipv6.conf.all.forwarding = 1
net.ipv4.conf.default.proxy_arp = 0

# Enables source route verification
net.ipv4.conf.all.rp_filter = 1

# Enables the magic-sysrq key
kernel.sysrq = 1

# We do not want all our interfaces to send redirects
net.ipv4.conf.default.send_redirects = 1
net.ipv4.conf.all.send_redirects = 0
EOL
echo "IPv4 forwarded to Conatiner"
sleep 2
cat >/etc/sysconfig/selinux <<EOL
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of these two values:
#     targeted - Targeted processes are protected,
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted

EOL
echo "Selinux Good Bye !"
sleep 2
yum install vzctl vzquota ploop -y
echo "Other Dependencies installed."
sleep 2

reboot
