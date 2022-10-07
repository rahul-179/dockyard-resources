#!/bin/bash -x

echo "Starting Script"
#packages
#install_eksctl() {
#curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
#sudo mv /tmp/eksctl /usr/local/bin
#}

e=0

#Get Information
cpu_core=$(getconf _NPROCESSORS_ONLN)
free_memory=$(free -m | awk 'NR==2 { print $7 }')
available_space=$(df -h | awk '{ print $4, $6 }' | grep -w "/" | awk '{ print $1 }' | tr -d G)

cpu=$(( ${cpu_core}/2))
space=$(( ${available_space}*70/100 ))
mem=$(( ${free_memory}/256*80/100 ))

echo ${cpu}
echo ${mem}
echo ${space}

#command -v eksctl && [[  $? -eq 0  ]] || install_eksctl
#eksctl get nodegroup --cluster $1 --region us-west-2
command -v stress-ng && [[  $? -eq 0  ]] || sudo apt-get -qq install stress-ng -y

stress-ng -m ${mem} -c ${cpu} -l 75 % -d ${space} -t $1 || { echo "command: stress-ng FAILED"; e=1; }

#eksctl get nodegroup --cluster $1 --region us-west-2
[[ ${e} == 0 ]] && echo "SCRIPT RAN SUCESSFULLY";
