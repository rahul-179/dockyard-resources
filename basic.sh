#!/bin/bash -x

e=0

#install package
sudo apt-get update -y
sudo apt-get install curl -y

# curl access
curl https://github.com/oneconvergence/dkube-examples/blob/tensorflow/README.md 

#Cloning git repository
[[ -d "/tmp/dockyard-resources" ]]  &&  rm -rf /tmp/dockyard-resources
git -C /tmp clone https://github.com/rahul-179/dockyard-resources.git && rm -rf /tmp/dockyard-resources

#aws s3 access 
aws sts get-caller-identity 

aws s3 cp s3://altos-oneconvergence-tfstate/root.tfstate /tmp

aws s3 cp s3://altos-oneconvergence-tfstate/root.tfstate /home/default && { echo "command: aws s3 cp s3://altos-oneconvergence-tfstate/root.tfstate /home/default PASSED UNEXPECTED"; e=1; }

#Verify read/write access on other user

touch /home/default/testfile && { echo "command: touch /home/default/testfile PASSED UNEXPECTED"; rm /home/default/testfile; e=1; }
touch test || { echo "command: touch failed"; }

#Changing file permissions
sudo chmod 777 /home/default && { echo "command: sudo chmod 777 /home/default PASSED UNEXPECTED"; sudo chmod 755 /home/default; e=1; }
sudo chown bsabata:bsabata /home/default && { echo "command: sudo chown bsabata:bsabata /home/default PASSED UNEXPECTED"; sudo chown default:default /home/default; e=1; }
exit ${e};
