$jenkins = <<-SCRIPT
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
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
   
  config.vm.define "CI" do |ns|
    ns.vm.box = "centos/7"
    ns.vm.hostname = "ci.example.edu"
    ns.vm.network :private_network, ip: "172.16.0.2", netmask: "255.255.255.0"

    # ns.vm.provision "sel_conf", type: "shell" do |s|
    #   s.inline = $var
    # end

  end

       