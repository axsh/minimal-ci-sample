#!/bin/bash
#

# package update
yum update -y

# setup clock
timedatectl set-timezone Asia/Tokyo

# selinux disabled
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# TODO: NetworkManager and firewalld disabled

# install git
yum install -y gcc gcc-c++ libcurl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker

git_download_dir=/usr/local/src
package="https://www.kernel.org/pub/software/scm/git/git-2.13.1.tar.gz"
package_name="${package##*/}"

curl -fSkL ${package} -o ${git_download_dir}/${package_name}
tar zxvf ${git_download_dir}/${package_name} -C ${git_download_dir}

( cd ${git_download_dir}/${package_name%.tar.gz}/ && make prefix=/usr all && make prefix=/usr install )

git --version

# install openjdk
yum install -y java-1.8.0-openjdk

# install jenkins
curl -fSkL http://pkg.jenkins-ci.org/redhat/jenkins.repo -o /etc/yum.repos.d/jenkins.repo
rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key

yum install -y jenkins

# setup jenkins
usermod -s /bin/bash jenkins

jenkins_dir=/var/lib/jenkins
[[ -d ${jenkins_dir}/.ssh ]] || mkdir -m 700 -p ${jenkins_dir}/.ssh

cat <<EOS > ${jenkins_dir}/.ssh/config
Host *
	ForwardAgent yes
	StrictHostKeyChecking no
	UserKnownHostsFile /dev/null
	TCPKeepAlive yes
EOS

chmod 644 ${jenkins_dir}/.ssh/config

tar zxvf /tmp/jenkins.tar.gz -C /var/lib/jenkins/

chown -R jenkins:jenkins /var/lib/jenkins

cat <<EOS > /etc/sudoers.d/jenkins
jenkins ALL = (ALL) NOPASSWD: ALL
EOS

chmod 440 /etc/sudoers.d/jenkins

#
service jenkins start

while ! curl -I -s http://localhost:8080/ -u ${JCLIUSER}:${JCLIPASSWD} | grep -q "200 OK"; do
	echo "Waiting for Jenkins..."
	sleep 3
done
echo "===> Jenkins is ready."

# Download jenkins-cli
curl -O http://localhost:8080/jnlpJars/jenkins-cli.jar

# install suggested jenkins-plugin
java -jar jenkins-cli.jar -s http://localhost:8080/ install-plugin dashboard-view cloudbees-folder antisamy-markup-formatter build-name-setter build-timeout config-file-provider credentials-binding embeddable-build-status rebuild ssh-agent throttle-concurrents timestamper ws-cleanup ant gradle msbuild nodejs checkstyle cobertura htmlpublisher junit warnings xunit workflow-aggregator github-branch-source pipeline-github-lib pipeline-stage-view build-pipeline-plugin conditional-buildstep jenkins-multijob-plugin parameterized-trigger copyartifact bitbucket clearcase cvs git git-parameter github gitlab-plugin p4 repo subversion teamconcert tfs matrix-project ssh-slaves windows-slaves matrix-auth pam-auth ldap role-strategy active-directory email-ext emailext-template mailer publish-over-ssh ssh --username ${JCLIUSER} --password ${JCLIPASSWD}

