#Infra as a code and Config as a Code

Using Terraform: AWS HA WEB app with Database

Here is the procedure for the network part:
•	Create a VPC with an IPv4 CIDR block of 10.0.0.0/16.
•	Creation of two public subnets on two different Availability Zones with two IPv4 CIDR blocks of 10.0.1.0/24 and 10.0.2.0/24.
•	Creation of two private subnets on the same availability zones as the public subnets with two CIDR IPv4 blocks of 10.0.3.0/24 and 10.0.4.0/24.
•	Creation of the Internet gateway.
•	Create a static IP address with the Elastic IP service to attach to your NAT gateway.
•	Creation of the NAT gateway.
•	Creation of a public and private routing table to associate with your respective subnets.
•	Create a 0.0.0.0/0 destination route to your Internet gateway in your public routing table.
•	Create a 0.0.0.0/0 destination route to your NAT gateway in your private routing table.

S3 and IAM role
Here is the  procedure to create your IAM role and S3 bucket:
•	Create an S3 bucket with a unique name and a ready-to-use "private" ACL , so no one else will have access rights to your bucket (except the owner). You also need to find a way to add the web application sources automatically to your bucket .
•	Creation of a role attached to EC2 services with a policy that authorizes full access to S3 services.
•	Create an instance profile to pass information related to the previously created role to your EC2 instances when they start.

You can use Endpoint VPCs to connect to your S3 service using a private network instead of the internet. You also have the option of creating a bastion host which is nothing more than an EC2 instance on your public subnet which is allowed to connect via SSH protocol to your EC2 instances located in your private subnets.
ELB and ASG

Here is the  procedure for creating your load balancer and AutoScaling Groups:
•	Creation of a security group for your ASG allowing only traffic coming from your ELB on port 80.
•	Create a security group for your ELB that only allows traffic from the internet on port 80.
•	Create a Target Group on port 80 to help your ELB route HTTP requests to instances in your ASG.
•	Creation of your "Application" type load balancer attached to your public subnet and your ELB security group.
•	Create an HTTP Listener attached to your ELB and Target Group to determine how your load balancer will route requests to the targets registered in your Target Group.
•	Create a launch configuration of your ASG where you will specify the friend, instance type ("t2.micro" to stay in the AWS free tier ), profile of instance with your IAM role, user-data, key pair, security group to use on your ASG instances.
•	Creation of your AutoScaling Groups where you will specify the launch configuration created previously, the private subnets on which your instances will be launched, your Target 

Group, an "ELB" type control and the desired / minimum / maximum number of your instances.
So that your ec2 instance is already ready and instantly configured during a scale up of your EC2 instances of your ASG, you have the choice between creating and using a personalized friend or creating and configuring everything from user-data. For this tp, I used the user-data method to concretely show you the commands executed when creating my new EC2 instances.

RDS
Here is the procedure to create your relational database:
•	Create a security group that only allows traffic from your web instances on port 3306.
•	Creation of your "mariadb" type database using the RDS service. It will be attached to your private subnet and the security group created earlier. Also, make sure that your MariaDB instance has a class of type "db.t2.micro", 20 GB of storage maximum and automated backups enabled with a retention period of one day so that you remain eligible for the offer. free from AWS . Finally, check that the "Multi-AZ" option is enabled.

CloudWatch Alarm
Here is the procedure for creating your CloudWatch alarm based on average CPU usage:
•	Creation of two AutoScaling strategies, one for scale up and another for scale down. The strategies will be of "simple" type in order to increase or decrease the current capacity of our ASG according to a single adjustment (eg: CPU usage). The adjustment will be of type "ChangeInCapacity" which will have as value "1" for the scale up strategies in order to add a single instance and "-1" for that of the scale down to remove only one instance.
•	Creation of two CloudWatch alarms, one will be based on the "CPUUtilization" metric with a usage threshold greater than or equal to 80% of CPU usage to trigger the ASG scale up strategy and another for a usage less than 5 % to trigger the ASG scale down strategy.
You can go further by creating email notifications from the AWS SNS service when one of ASG's policies is triggered .
The sources of our application and TP requirements

This application coded in php allows quite simply to post an article which is then saved on our mysql database. Here are some indications on two source files that you must take into consideration:
•	db-config.php : contains the configuration required for your application to communicate with your database, you will find:
o	## DB_HOST ## : replace with the ip or dns name of your database.
o	## DB_USER ## : to be replaced by the username of your database.
o	## DB_PASSWORD ## : to be replaced by the user password of your database.
•	hishab-db.sql : contains the SQL query to execute to create the architecture of your table in your database.



Project launch and test
To use this project, must first start by specifying the root password of our database. I chose to define it in a file named terraform.tfvars

db_password = "hishabexamplepass"
You must then create your ssh key pair in the keys folder . In my case, I am using the ssh-keygen command as follows:

ssh-keygen -t rsa

Generating public/private rsa key pair.
Enter file in which to save the key (/home/emran/.ssh/id_rsa): ./keys/terraform
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Then add the path of your public key in the path_to_public_key parameter of the my_alb_asg module . it will be:

module "my_alb_asg" {
    ...
    ...
    path_to_public_key   = "/home/emran/Documents/tmp/terraform/sources/keys/terraform.pub"
    ...
    ...
}
Then launch our project with the following command:

terraform init && terraform apply
Result:

...
...

Outputs:

alb_dns_name = devopssec-alb-303689240.us-west-2.elb.amazonaws.com

To verify that our ELB redirects traffic to the different web instances of our ASG, I added sample webpage. 
