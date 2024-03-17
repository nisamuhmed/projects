# Zomato Web Demo CI/CD Jenkins

This project is Continuous Integration and Continuous Deployment (CI/CD) pipeline for the Zomato Web Demo using Jenkins.
And it's be done in two different methods.

## Overview

CI/CD is a method to frequently deliver apps to customers by introducing automation into the stages of app development.
It's been the main component of the software development cycle, with so many configurations and tools available.
It's possible to use two pipelines for one project and done in this project.


## Prerequisites

Setup and install the below steps before going any further:

 1. **AWS EC2 Instance**    
    - Launch a Linux machune in AWS EC2 instance (eg: Ubundu).
    - Ensure that the machine has sufficient requirements to run Jenkins.
      
 3. **Jenkins**
    - Install Jenkins.
    - Install the required plugins.
      
      *nb: all these prerequisites steps are expalined below*
    
 4. **Docker**
    - Install and start docker.
    - Before building the job add jenkins to docker supplymentary group.
    
 5. **Node.js and npm**
    - Install nodejs and npm.
    - Verify the installation by running ```node -v``` and ```npm -v``` commands.
    
 7. **Nginx**
    - Install and configure Nginx.
    - Set up Nginx to serve static files from the ```/var/www/html``` directory.

## Installation Steps

* Create a shell script file to setup the above packages ```vim jenkins.sh``` or do these steps in cli
  
  ```
  #!/bin/bash
  
  #jenkins installation
  sudo apt update -y
  sudo apt install fontconfig openjdk-17-jre -y
  sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
  sudo apt-get update
  sudo apt-get install jenkins -y
  sudo systemctl start jenkins

  #docker installation
  sudo apt install docker.io -y
  sudo systemctl start docker

  #nodejs installation
  sudo apt install nodejs -y
  sudo apt install npm -y


  #nginx installation for deploying
  sudo apt install nginx -y
  sudo systemctl start nginx
  sudo chown -R jenkins /var/www/html  #for writing build files
  ```
  
* And run the created .sh file

  ```
  chmod +x jenkins.sh
  ./jenkins.sh
  ```
  
## Setup Jenkins

* Browse ```https://<instance_public_ip>:8080```
  
  *nb: add the port number 8080 to EC2 Security Group*

* Login using the Administrative Password, it's stored in this file.
  
  ```
  cat /var/lib/jenkins/secrets/initialAdminPassword
  ```
  
* Install suggested plugins and Access Jenkins through the created user in next step.
  
  ![Screenshot (236)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/afb00bf3-8d72-461e-bcb8-7b77b254192a)
  ![Screenshot (238)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/35a5aeb3-6867-42de-afb2-492e047dbed5)

* Install required Jenkins plugins from *Dashboard>Manage Jenkins>Plugins>Available Plugins*.
  
  ![Screenshot (246)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/60217753-d168-4249-8c9b-a6a4b908c750)


## Create a Pipeline for Nginx

 * This pipeline will deploy the app to Nginx webserver. The steps are listed below:
 
   ![Screenshot (241)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/3f9ddedf-9cc2-433c-b596-6ee25330bf90)

 * **Git Clone:** This stage will clone the Zomato-Demo-CICD repository from Github ```main``` branch.
 
 * **Install Dependancies:** This stage installs required dependencies for building and running the app using npm.
 
 * **Build:** This stage builds the app using ```npm run build``` command. It compiles the JavaScript and CSS files and generates an optimized production build.

 * **Deploy:** This stage deploys the built app to Nginx, And it copies the ```build``` directory ```/var/www/html```, which is the common location for serving static files on a web server.
 
    *nb: enable **Github hook trigger for GITScm polling***
   
   ![Screenshot (242)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/94649a1b-c320-4213-ab6f-10008f93b9a0)

## Build the pipeline

 * Build the pipeline to see if it's stable.

   ![Screenshot (244)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/9bb1b94e-e5ce-4add-be10-4cab2951ed1e)

 * Browse ```https://<instance_public_ip>``` to get the hosted app
   
   ![Screenshot (245)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/5c319198-ca89-4e30-82c3-d49065151c33)

## Setup Github Webhook

 * Github webhook Integrates Github repository with Jenkins, with this the repository can be automated.
   Now this webhook will be set to trigger the pipeline to build every time the repository push happen.
   Enable **Github hook trigger for GITScm polling** in pipeline for the pipeline to be triggered by the webhook.

   ![Screenshot (251)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/d67fd49f-fa6a-4fd2-98c0-94edeeed86a5)
   ![Screenshot (252)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/883664ef-afc0-4ace-b0df-f196e3cc85c2)


## Create a pipeline for docker

 * Using docker to deploy is another method.
   Now the app is running on the Server and if the service stops the app will be no longer available to others so for the app to be accessible anywhere by anyone dockerizing is a good option.
   
 * It's also possible to include both these pipeline in one but this would be much faster, clean and less requirements are needed.

 * Docker pipeline steps are listed below:

   ![Screenshot (257)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/dd00c01b-f572-4eef-9c5e-84ed2805ff51)

*  Clone the Git repository.
*  Building a Docker image ```docker build . -t zomato_web_demo``` using this command (zomato_web_demo is the image name).
*  Creating a container from the image ```docker run -d --name zomato_web_app -p 3000:3000 zomato_web_demo``` and port is forwarded to 3000 (zomato_web_app is conatiner name). Before creating a Container the container with same name is removed using this command ```docker rm -f zomato_web_demo``` for the latest container to be created.
  
   *nb: add the port number 3000 to EC2 Security Group*

    ![Screenshot (260)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/d0a64e0c-c89f-43ee-ab52-9bdd7e68b940)


 * Docker is already installed and started. The Dockerfile is set in repository (it's in shown below for reference).

   ```
   # Node.js 16 slim as the base image
   FROM node:16-slim

   # To Set the working directory
   WORKDIR /app

   # For Copying package .json and package-lock.json to working directory
   COPY package*.json ./

   # Install dependencies
   RUN npm install

   # Copying the rest of the code
   COPY . .

   # Build the React app
   RUN npm run build

   # Expose port 3000 (nodejs port)
   EXPOSE 3000

   # Start Node.js server
   CMD ["npm", "start"]
   ```

   *nb: add the port number 3000 to EC2 Security Group*

 * Also this pipeline is set to trigger the build after *pipeline1* is built. And enabled **Github hook trigger for GITScm polling** as mentioned before.

   ![Screenshot (259)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/0257059e-dce9-4712-9fd7-437cd4b6b198)

## Commit changes in Git repo

 * Made a little change in */src/components/Header/Header.jsx* file, removed these marked texts below:

   ![Screenshot (261)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/8e1f10ab-518d-4fb0-b01e-ad0d301658cf)
   ![Screenshot (262)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/6aa286c0-6a8d-4dd8-9758-4af314a9bff7)

## Pipelines1 is triggered

 * The *pipeline1* is triggered and built by commit done in github.

   ![Screenshot (263)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/34fa0bb0-d0e2-4840-9e72-f92330483f9b)

 * As mentioned in Console Output below push is done by Github user

   ![Screenshot (264)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/b93d2dfc-c21a-4192-ad17-855adb8d98ff)

 * Refresh the browsed page and the changes will be seen (text shown in the search bar is different from before).

   ![Screenshot (269)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/0337ca40-e23e-4f68-9dac-0a6133c92e58)

## Pipelines2 is triggered
 
 * After *pipeline1* is built *pipeline2* is triggered and built.

   ![Screenshot (265)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/6c8f34a7-f32b-42b5-8893-ee8599b7a2e1)

 * It's mentioned in the Console output started by upstream project, means it triggred by the *pipeline1* build.

   ![Screenshot (266)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/9bb9db17-b318-401d-a833-970208b438bb)

 * Browse ```https://<instance_public_ip>:3000```
   And output of this pipeline is changed also as expected

   ![Screenshot (270)](https://github.com/nisamuhmed/Zomato-Demo-CICD/assets/156061244/f3e7ddff-327e-4ec7-8fca-f42d91b81f08)

## Conclusion

This project demonstrates how Jenkins, Docker, and Nginx team up for smooth deployments. As Jenkins is commonly used tool in devops field any beginner should know a little and that's what this mini project is about. After completing this it's sure that these tools are all really useful and a must in these days. Feel free to tweak and play around with this setup.

****************************************************************************************************************************************************************************************************************************
