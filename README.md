# REA practical task
# Provision a new application server and deploy the application 

## **Requirements:**

 - AWS account
 - Unix terminal
 - Ansible-playbook
 - Programmatic access to your AWS account (i.e. AWS access key, AWS
   secret key required to be updated in your aws credentials - ~/.aws/credentials
 - Assumed you have VPC/Subnet that you want your vm deployed to. I
   have used the default VPC/subnet for this task.  Change the VPC id, Subnet id as
   per your requirements, update all.yaml inventory file under
   cicd/ansible/inventory/group_vars folder.
 - To have ssh access to EC2 instance you also need to update 'CIDRIPSSH'
   in all.yaml inventory file under cicd/ansible/inventory/group_vars
   folder. Update the value with the source ip address i.e. "10.0.0.113/32".
 - KeyPair - 'rea.pem' is included along with this project.

## **How to execute the code**

 - Clone the repository:
	*`git clone https://github.com/divyeshjoshi-2019/rea.git`*
 - CD to the rea git folder.
 - Run the Ansible playbook command below to validate the templates. (This
   command uses yamllint and cfnlint to validate the templates).
   *`ansible-playbook -i cicd/ansible/inventory/prd cicd/ansible/cf-stacks.yml --tags validate`*
   
 - Run the Ansible playbook command below to deploy the templates as
   well as the application.
*`ansible-playbook -i cicd/ansible/inventory/prd cicd/ansible/cf-stacks.yml --tags deploy`*
  
You can see the status in the cloudformation stacks while the templates are being deployed.
**Note:** The code to deply application is part of the user data script in the code so with the end of deployments, expect the application is already up and running.
## **Confirm application is running..**
With the DNS record created, you should be able to access the application using the below url: http://rea.app.cloud.
Note this url can only be accessed withing the VPC range or the dns record won't resolve to the IP address of the host
 - DNS record: http://rea.app.cloud
 - DNS record points to the NLBLoadBalancer.DNSName on port 80 which then points to the EC2 instance on port 9292. 

If successful, you should receive a page with 'Hello World' text.
                                                                                                   
## **Explanation of assumptions and design choices**

 - [AWS Design](https://cloudcraft.co/view/bc0a06a7-8422-48f8-ae96-7b2ccd1042f5?key=ngtbF8OiCfbkK9cU3b82Cw)
 - EC2 instance type: t2.micro
 - AMI: Amazone Linux
*Assumption*: Did not have context as to the load on the server or any     OS requirements so I chose the default one)
 - Route53: DNS Name for the application
 - NLB: Use of NLB is just to put the EC2 instance behind the Load
   Balancer so that the application can be hit on port 9292 but having
   load balancer listener on http.  Security Group/s: Used to secure EC2
   instance. Can only be ssh via the given CIDR. However application is
   still accessible on port 80 by anyone on Internet.
 - ENI: Mainly for the failover purpose. ENI can be attached/detached
   to/from any instance respectively.
 - Ansible-Playbook: To deploy multiple cloudformation stacks with ease

**Could have used/added:**

 - Auto-scaling group: to have redundancy and scalability as well but
   with the limited time this wasn't possible.
 - Jenkinsfile: to trigger the deployment from Jenkins whenever any
   changes are made to the repository.
 - WAF: to make the application more secure Custom EC2 monitoring:
   Memory metrics etc.
