![la logo](https://user-images.githubusercontent.com/42839573/67322755-818e9400-f4df-11e9-97c1-388bf357353d.png)

### Kubernetes Security
### Linux Commands Summary and Guide

#### Preparing the Playground Servers

From linuxacademy.com, Cloud Servers -> Playground

Set up Medium Servers with CentOS in our Cloud Playgrounds. Label one as Master, and a second as Worker Node1, and a third as Worker Node2.

You may change the Zone from North America but please use the same Zone for all three servers.

Copy off the Public IP Address and the cloud_user credentials; the login and temporary password. 

#### Setting Up The Master Nodes

The URL for the course assets in GitHub are at:
https://github.com/ACloudGuru-Resources/content-kubernetes-security

Access your servers through the SSH utility on your client or our terminal session provided through linuxacademy.com.

` $ ssh cloud_user@<Your Server Public IP Here> `

Use the temporary password for first login, and when it prompts you to change the password, set the password to whatever you choose.

#### On the master Node:

Run a wget command to pull down the script that will pull the others.

` $ wget https://raw.github.com/ACloudGuru-Resources/content-kubernetes-security/master/wget_shell_files.sh `

Change the permissions to add execute permission to the shell script file.

` $ chmod +x wget_shell_files.sh `

Execute the shell script from your current working directory.

` $ ./wget_shell_files.sh `

#### On the Worker Nodes

Repeat the wget of the main shell script on Node1 and Node2 servers.

` $ wget https://raw.github.com/ACloudGuru-Resources/content-kubernetes-security/master/wget_shell_files.sh `

Change the permissions to add execute permission to the shell script file.

` $ chmod +x wget_shell_files.sh `

Execute the shell script from your current working directory.

` $ ./wget_shell_files.sh `

#### Back On the Master Node

Use the sudo command to become the super user.

` $ sudo su `

Use the chmod command to grant execute permission to all of the shell script files.

` # chmod +x *.sh `

Then from the present working directory, that contains all of the downloaded scripts, run the first script.

` # ./ks-setup-step1.sh `

> NOTE: The above script will make some configuration edits to your server and reboot the server, so your ssh connection will be closed.

After your servers reboot, you will need to restablish your ssh session. YOU MAY NEED TO VERIFY in linuxacademy.com whether the Public IP Address for your servers has changed. If so, make note of the new IP’s as before. Your passwords will not have changed.

After you reestablish your session as cloud_user, use the sudo command to become super user.

` $ sudo su `

From the directory containing the scripts, run the second setup script.

` # ./ks-setup-step2.sh `

Verify that docker is installed.

` # docker version `

Verify that kubeadm has been installed.

` # kubeadm version `

Enter the command (on the master node) to initiate a cluster.

` # kubeadm init –-pod-network-cidr=10.244.0.0/16 `

> NOTE: The –-pod-network-cidr address pool being supplied is intended to facilitate the use of the flannel network overlay which will be installed in a subsequent step.

> VERY IMPORTANT
Copy off the kubeadm join command that is presented when the kubeadm init completes. That join command has a token that is needed by the worker nodes to join the master.

> ALSO NOTE: kubeadm creates tokens for the worker nodes to join and they expire within 24 hours. So you will want to join your nodes to the cluster soon after configuring the master node.

Copy off the commands presented that are necessary to copy the config file for kubectl.

Now exit the super user shell session.

` $ exit `

Use cd to change to your home directory if necessary.

` $ cd `

Create the hidden directory called .kube.

` $ mkdir -p .kube `

Copy the kubernetes admin configuration from /etc/kubernetes to the .kube directory in our home path, and name it config.

` $ sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config `

Change ownership and group ownership of the config file to cloud_user.

` $ sudo chown $(id -u):$(id -g) $HOME/.kube/config `

Use kubectl to see the status of the master node.

` $ kubectl get nodes `

Install the flannel network overlay with this command.

` $ kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml `

Continue to execute a get nodes command until your master is ready.

` $ kubectl get nodes `

#### Setting Up The Worker Nodes (Perform these commands on both worker nodes)

One the worker nodes, establish a super user session

` $ sudo su`

Change the shell files to add execute permission.

`# chmod +x *.sh`

Execute the first setup script.

` # ./ks-setup-step1.sh`

> NOTE: This script will disconnect you and reboot the server, just as it did on the master node.

After your servers have rebooted, reestablish a ssh session on both worker nodes.

Execute the script to do the step2 installs.

` $ sudo su `

` # ./ks-setup-step2.sh `

Verify that docker and kubeadm are installed.

` # docker version `

` # kubeadm version `

Using the kubeadm join command that you copied off before, join the worker node to your master.

` # kubeadm join <Your Master IP>:6443 --token <token> --discovery-token-ca-cert-hash sha<Your CA Certificate Data> `

Now, back on the master, use kubectl to determine that the worker nodes have joined the cluster.

` $ kubectl get nodes `

#### Validating The Cluster

On the master node. Use kubectl to exercise a few commands to validate the cluster.

` $ kubectl get namespaces `

` $ kubectl get roles --all-namespaces `

` $ kubectl get serviceaccounts --all-namespaces `

Test your cluster by doing a deployment.

` $ kubectl create deployment hello-node --image=gcr.io/hello-minikube-zero-install/hello-node `

Verify the deployment is ready.

` $ kubectl get deployments `

Verify the deployment launched the pod.

` $ kubectl get pods `

Use the get events command to review the events that have been performed on your cluster.

` $ kubectl get events `

Then, when you are ready delete the deployment to clean up.

` $ kubectl delete deployment/hello-node `

#### Some Other Helpful Commands

Throughout the course it is useful to be able to interrogate your cluster of a variety or resources that may exist. You may also use abbreviations or ‘shortnames’ of most resource names. To view all of the resources and their abbreviation, use the command:

` $ kubectl api-resources `


To Re-Instantiate Your Cluster WITHOUT recreating your Cloud Playground Server Images

On the Master and Worker Nodes

` # kubeadm reset `

Then just repeat the init command on the master.

` # kubeadm init –pod-network-cidr=10.244.0.0/16 `

> NOTE: Copy off the join commands

Configure kubectl as before in .kube, just with the copy and chmod if needed.

` $ sudo cp -I /etc/kubernetes/admin.conf $HOME/.kube/config `
` $ sudo chown $(id -u):$(id -g) $HOME/.kube/config `

Use kubectl to see the status of the master node.

` $ kubectl get nodes `

Install the flannel network overlay with this command.

` $ kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml `

And use the join commands to rejoin the worker nodes.

