# Deployment of a Web page into AWS-S3-Bucket using GitHub Workflows

This project establish how to automate the deployment of a webpage built with CSS, HTML, and JavaScript to an AWS S3 Bucket using GitHub Workflows.

## Overview

GitHub Workflows simplify and automate the deployment process. By integrating GitHub Workflows with S3, developers create a seamless deployment pipeline triggered by repository changes. This includes fetching code updates, building the site, running tests, and deploying to S3. Customizable workflows ensure smooth and reliable deployments, enhancing development efficiency. 

## Prerequisites

Make sure you have the following:

- A GitHub account.
- An AWS account.
- Webpage files (HTML, CSS, JavaScript, etc.) stored in GitHub repository.

## Deployment Steps

1. **Check the Webpage files**: This webpage a live Neon-clock that shows current time your machine. Ensure these website script files including HTML, CSS, JavaScript, and any other assets, are ready for deployment. These files should be stored in your GitHub repository.

2. **Configure AWS Credentials**: Set up AWS credentials in your GitHub repository secrets to allow GitHub Actions to access AWS account. This step is necessary for deploying the webpage to S3 Bucket.

3. **Create GitHub Workflow**: Create a GitHub Workflow file (e.g. `deploy.yml`) in the `.github/workflows` directory of  repository. This workflow file defines the steps to be executed by GitHub Actions when triggered. It includes steps to Setup Job, Checkout code, Configure AWS Credentials, Deploy to the S3 Bucket, etc.

4. **Test Workflow**: Test GitHub Workflow to ensure that it runs successfully and deploys static website to the AWS S3 Bucket as expected. This can be done by pushing changes to repository and monitoring the workflow execution in the Actions tab of GitHub repository.

## Example Workflow File

 * Example of a GitHub Workflow file (`deploy.yml`) that deploys website files to S3 Bucket:

   ```yaml
   name: Deployment
   
   on:
     push:
       branches:
       - main

   jobs:
     build-and-deploy:
       runs-on: ubuntu-latest
       steps:
       - name: Checkout
         uses: actions/checkout@v1
       - name: Configure AWS Credentials
         uses: aws-actions/configure-aws-credentials@v1
         with:
           aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
           aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
           aws-region: <aws-region>
       - name: Deploy static site to S3 bucket
         run: aws s3 sync . s3://<bucket-name>
    ```

## Workflow Steps

 * The Actions and Workflow steps are accessible in this [Repo](https://github.com/nisamuhmed/Github-Workflow-AWS-S3.git)-[Actions](https://github.com/nisamuhmed/Github-Workflow-AWS-S3/actions/runs/8371112817/job/22919586621).

   ![Screenshot (513)](https://github.com/nisamuhmed/Github-Workflow-AWS-S3/assets/156061244/b445ea76-6555-44d0-a98d-5eb31fb0d6e7)

## Deployed Objects

 * The Github repo was deployed to S3 bucket shown below by Github Workflows:

   ![Screenshot (514)](https://github.com/nisamuhmed/Github-Workflow-AWS-S3/assets/156061244/a6887aeb-ca88-4784-ba8a-052dcaa0f785)


## Output

- Make all Objects stored in S3 Bucket public using ACL.
- Access Index.html object url through a Browser.

  ![Screenshot (518)](https://github.com/nisamuhmed/Github-Workflow-AWS-S3/assets/156061244/2373120e-f6af-4105-b04c-e17824655d1a)
  ![neon-clock s3 us-west-2 amazonaws com_index html - Personal - Microsoft_ Edge 2024-03-20 23-45-11 (2)](https://github.com/nisamuhmed/Github-Workflow-AWS-S3/assets/156061244/c993c314-00af-40a1-8e03-9d8f4253e037)

