$jenkins = <<-SCRIPT
sudo wget -O /etc/yum.repos.d/jenkici.repo http://pkg.jenkins-ci.org/redhat-stable/jenkici.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum -y install jenkins
SCRIPT

$java = <<-SCRIPT
sudo yum -y install java
sudo yum -y install java-1.8.0-openjdk
SCRIPT


$git = <<-SCRIPT
sudo yum install git
SCRIPT

$ansible = <<-SCRIPT
sudo yum install epel-release
sudo yum install ansible
SCRIPT

$artifactory = <<-SCRIPT
wget https://bintray.com/jfrog/artifactory-rpms/rpm -O bintray-jfrog-artifactory-rpms.repo
sudo mv bintray-jfrog-artifactory-rpms.repo /etc/yum.repos.d/
sudo yum install jfrog-artifactory-oss
SCRIPT

sudo yum install epel-release

Vagrant.configure("2") do |config|
    config.vm.provider "virtualbox" do |v|
          v.linked_clone = true
          v.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "1"]
        end
   
  config.vm.define "CI" do |ci|
    ci.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "1"]
    ci.vm.box = "centos/7"
    ci.vm.hostname = "ci.example.edu"
    ci.vm.network :private_network, ip: "172.16.0.2", netmask: "255.255.255.0"
    ci.vm.provision "shell", inline: $jenkins
    ci.vm.provision "shell", inline: $java
    ci.vm.provision "shell", inline: $git
    ci.vm.provision "shell", inline: $ansible
    ci.vm.provision "shell", inline: $artifactory
   
  end

       