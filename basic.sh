#!/bin/bash -x

#install package
sudo apt-get update -y || { echo "command: apt update failed"; }
sudo apt-get install curl -y || { echo"command: apt install curl failed"; }

# curl access
curl https://github.com/oneconvergence/dkube-examples/blob/tensorflow/README.md || { echo "command: curl https://github.com/oneconvergence/dkube-examples/blob/tensorflow/README.md FAILED"; }

#Cloning git repository
[[ -d "./dockyard-resources" ]]  &&  sudo rm -rf ./dockyard-resources
git clone https://github.com/rahul-179/dockyard-resources.git || { echo "command: git clone failed"; }

#aws s3 access 
aws sts get-caller-identity || { echo "command aws sts get-caller-identity FAILED"; }

aws s3 cp s3://altos-oneconvergence-tfstate/root.tfstate . || { echo "command: aws s3 cp to current dir FAILED"; }

aws s3 cp s3://altos-oneconvergence-tfstate/root.tfstate /home/default && { echo "command: aws s3 cp s3://altos-oneconvergence-tfstate/root.tfstate /home/default PASSED UNEXPECTED" && sudo rm -rf /home/default/root.tf; }

#Verify read/write access on other user

touch /home/default/testfile && { echo "command: touch /home/default/testfile PASSED UNEXPECTED"; rm /home/default/testfile; }
touch test || { echo "command: touch failed"; }

#Changing file permissions
sudo chmod 777 /home/default && { echo "command: sudo chmod 777 /home/default PASSED UNEXPECTED"; sudo chmod 755 /home/default; }
sudo chown bsabata:bsabata /home/default && { echo "command: sudo chown bsabata:bsabata /home/default PASSED UNEXPECTED"; sudo chown default:default /home/default; }
