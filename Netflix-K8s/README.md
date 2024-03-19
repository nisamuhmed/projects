# Deployment of Netflix Web Demo on Amazon EKS using Terraform

This project demonstrates how to deploy a Netflix Web Demo on AWS EKS using Terraform for infrastructure provisioning.
![NetliflixK8s](https://github.com/nisamuhmed/projects/assets/156061244/192ce4fe-e58d-4288-9010-c0950a59a7d6)


## Overview

Netflix is a subscription-based streaming service that offers movies, TV shows, documentaries, and more on thousands of internet-connected devices.
This project aims to deploy a Web Demo of Netflix on a Kubernetes cluster. The infrastructure provisioning is handled by Terraform, which automates the deployment process.

## Prerequisites

Before begin, ensure to have the following installed:

- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/): Kubernetes command-line tool allows users to communicate with the Kubernetes API server and control Kubernetes clusters.
- [Terraform](https://www.terraform.io/): For infrastructure provisioning. Using terraform EKS-Cluster is configured and  made accessible.
- Docker: Docker is required for containerization. Docker can be installed by following the instructions provided on the [Docker website](https://docs.docker.com/get-docker/).
- AWS CLI: For deploying to AWS, you need AWS CLI to interact with AWS services. AWS CLI can be installed by following the instructions provided [here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html) based on Operating System.

## Launch an AWS EC2 Instance

 * Sign in to your AWS console.
 * Launch a new  EC2 instance (eg: Ubuntu).
 * Connect to the instance via SSH.

## Installation Steps

 * Update package lists:

    ```bash
    sudo apt update
    ```

 * Install Kubernetes tools:

    ```bash
    sudo apt install -y apt-transport-https curl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    ```

   
 * Verify Kubernetes installation:

    ```bash
    kubectl version --client
    ```

   <img width="960" alt="Screenshot 2024-03-17 070540" src="https://github.com/nisamuhmed/projects/assets/156061244/48d945b4-afad-42f6-968e-3cdfe0c38359">

 * Install Terraform:

    ```bash
   wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install terraform
    ```

   <img width="960" alt="Screenshot 2024-03-17 070634" src="https://github.com/nisamuhmed/projects/assets/156061244/b24f05cd-3e3b-4d4a-b8f3-b709c67574b1">


 * Install and Setup AWS CLI:

   ```bash
   curl “https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o “awscliv2.zip”
   sudo apt-get install unzip -y
   unzip awscliv2.zip
   sudo ./aws/install
   ```
   
   <img width="960" alt="Screenshot 2024-03-17 070727" src="https://github.com/nisamuhmed/projects/assets/156061244/f806fd1b-4a10-43a1-b064-d93d9c877fed">
  
 * Configure AWS by inserting credentials:
   
   ```bash
   aws configure
   ```

 * Install Docker:

   ```bash
   sudo apt install docker.io -y
   sudo usermod -aG docker "username"
   newgrp docker  #adding current user to docker group
   ```   
   <img width="960" alt="Screenshot 2024-03-17 070800" src="https://github.com/nisamuhmed/projects/assets/156061244/4e664d25-43c4-4d94-9b56-1d29f26ecdbd">

   
## Deployment Steps

 * Clone this repository:

    ```bash
    git clone https://github.com/nisamuhmed/projects.git
    ```

 * Navigate to the project directory:

    ```bash
    cd projects/Netflix-K8s/
    ```

    <img width="960" alt="Screenshot 2024-03-17 071042" src="https://github.com/nisamuhmed/projects/assets/156061244/aa427104-0de1-46fd-bade-303ae4bd1f01">


 * Configure Terraform:

   ```bash
   cd terraform
   vim backend.tf
   ```
   
   <img width="960" alt="Screenshot 2024-03-17 071127" src="https://github.com/nisamuhmed/projects/assets/156061244/17d19a71-740e-4fdd-a8f9-be55067471f3">
   

   - Replace with actual bucket-name. If you don't have a S3 Bucket then Create one in AWS.     
   - In `main.tf`, defines  cluster name, node group name, desired capacity, and max capacity.

   
 * Create an IAM Role with AdministratorAccess Permission for EC2:

    ![Screenshot (453)](https://github.com/nisamuhmed/projects/assets/156061244/6189aff6-0ad5-40a5-909b-620784d0e7c2)


    - **IAM role for EC2:** It is used by the ec2 instance to create EKS cluster and manage s3 bucket. By applying this IAM role it gives the authenticity to your ec2 to do any changes in aws account.
    - Attach IAM Role to Instance.
      
    ![Screenshot (454)](https://github.com/nisamuhmed/projects/assets/156061244/f00abab1-725c-46e2-8d20-94d247331e06)


 * Initialize Terraform:

    ```bash
    terraform init
    ```

    <img width="960" alt="Screenshot 2024-03-17 071357" src="https://github.com/nisamuhmed/projects/assets/156061244/c05e531f-4791-4d75-80b1-d61879293e15">


 * Plan the deployment:

    ```bash
    terraform plan
    ```

    ![Screenshot (456)](https://github.com/nisamuhmed/projects/assets/156061244/26deed7c-3030-4926-aafe-c772130b3f78)


 * Deploy Netflix to Kubernetes:

    ```bash
    terraform apply --auto-approve
    ```
    
    ![Screenshot (457)](https://github.com/nisamuhmed/projects/assets/156061244/b18882eb-55d1-4d60-ab56-a7dba3530afa)
    ![Screenshot (402)](https://github.com/nisamuhmed/projects/assets/156061244/122876a0-82f0-432f-8330-3e862fdd925b)
    ![Screenshot (403)](https://github.com/nisamuhmed/projects/assets/156061244/7cdf360f-69e6-464b-8ce2-a1f7fc02d638)

 * Update kubeconfig:
   
    ```bash
    aws eks update-kubeconfig --name EKS_CLOUD --region us-west-1
    ```

    <img width="960" alt="Screenshot 2024-03-18 232026" src="https://github.com/nisamuhmed/projects/assets/156061244/f3f5bcf5-f356-4474-80de-2c289609d944">




 * Apply YAML files:

    ```bash
    cd ..
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml
    kubectl get pods
    ```

    <img width="960" alt="Screenshot 2024-03-17 073547" src="https://github.com/nisamuhmed/projects/assets/156061244/af690aaa-3f1a-43f9-b569-693e6b2e7899">

    * Make sure pods are in running state.


 * Access Netflix Demo:

    * Once the deployment is complete, access Netflix using the provided endpoint.  
    * Run the following command to get the load balancer ingress.
      
    ```bash
    kubectl describe service natflix-service
    ```
    ![Screenshot (459)](https://github.com/nisamuhmed/projects/assets/156061244/79b3716f-5ec0-434d-8ccd-e8511ee0d6ab)

      
    - Ensure to Allow HTTP and HTTPS port on your SecurityGroup. 
    - Copy the load balancer ingress and paste it on a browser to get the output.
   
    ![Screenshot (460)](https://github.com/nisamuhmed/projects/assets/156061244/04e8604a-6d6c-4e5f-9dac-39cc184e4f59)
    
      
    - **Load Balancer Ingress:**   It is a mechanism that helps distribute incoming internet traffic among multiple servers or services, ensuring efficient and reliable delivery of requests.a Load Balancer Ingress helps maintain a smooth user experience, improves application performance, and ensures that no single server becomes overwhelmed with too much traffic.

    
## Cleanup

 * To remove Netflix deployment and associated resources from Kubernetes cluster:

    ```bash
    kubectl delete service netflix-service
    kubectl delete deployment natflix-deployment
    cd terraform
    terraform destroy --auto-approve
    ```

    ![Screenshot (461)](https://github.com/nisamuhmed/projects/assets/156061244/e1d18944-bb40-4179-9fd0-a6a1bc28a41d)



