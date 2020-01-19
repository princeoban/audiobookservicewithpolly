# Audiobook Service With Amazon Polly
Audiobook Generator Using AWS POLLY

AWS Polly is a service that helps convert of text into Speech, making it useful for creating audiobooks. AWS Polly has a Character limitation of 1,500 Characters but using it with AWS Batch, you can break every text file uploaded into smaller jobs and Batch Controls how each are sent to Polly For Synthesising and outputs One mp3 File of the whole text file uploaded.

### Solution Architecture

### Getting Started

This Solution helps you create the Cloud Formation Stack needed to get the AudioBook Service Configured on your AWS Account. For this you will be needing an aws account and also BASH to run the script from your command prompt or Terminal.

Some of the services are going to bill your AWS account. not to worry, you can use the "destroy_stack.sh" script to delete the stack and all components after you done with the Set-Up.

### Prerequisite
1. AWS Account 
2. Scripting Knowledge (Don't worry if you don't have. Just Follow my step and you'd get everything you need)

#### Step 1 - AWS Account
if you don't have an AWS, please go to https://portal.aws.amazon.com/billing/signup#/start to create an account. After creating the account, go to Services, IAM, and create a user with administrator access. You can follow the link below to get a break down of how to create an admin user:
https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html

After creating the user, download the credential file for the user (Access key ID & Secret Key), open the file and copy out the access key ID & Secret Key.

#### Step 2 - AWS CLI
Most of our solution will be communicating with AWS through its Command Line Interface (CLI). If AWS CLI isn't installed on your command line or Terminal, please follow the link before to have it installed: 

Windows : https://docs.aws.amazon.com/cli/latest/userguide/install-windows.html

Mac : https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html

After installing, we need to configure our AWS credentials on CLI so that all communications with the AWS with be using the user IAM and permissions.

Open the Terminal and enter: $ aws configure

you will be prompted to enter your access Key ID like this, 

"AWS Access Key ID [None]:"  Paste your access Key ID gotten from the credential file earlier


Afterwards you will be prompted for your Secret Access Key like this,  

"AWS Secret Access Key [None]:" Paste the secret access key also gotten from the credential file


You will be prompted for your default Region name like this, 

"Default region name [None]:" ,  type "us-west-2" (Oregon Region- Part of the few regions where AWS Polly is available)


You will be prompted for your default output format like this, 

"Default output format [None]:" ,  type "json" 



After this, you will need to set the access Key ID and Secreary Access Key to environment Variables. To do this:

##### Windows:

use set :

set AWS_ACCESS_KEY_ID=your_access_key_id (press Enter)

set AWS_SECRET_ACCESS_KEY=your_secret_access_key (press Enter)

##### MacOS:

use export :

export AWS_ACCESS_KEY_ID=your_access_key_id (press Enter)

export AWS_SECRET_ACCESS_KEY=your_secret_access_key (press Enter)

After this, your AWS command line configuration is complete and can move to the next step


#### Step 3 - Install Bash On MacOS Or Windows

Next Step is to install Bash on Mac or Windows necessary to run the scripts for creating the cloud formation Stacks. if you already have Bash installed on your computer and familiar with using Bash, please proceed to the next step. If you do not have, follow the links below to install on respective OS.

##### Windows:

Go to the link below to install linux bash shell On Windows 10

https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/

After installing Bash, create a BIN directory where you will be saving the script files needed to create the cloud formation stack

cd ~      # this takes us to home directory /Users/kolapo (this is my home directory. Replace it with your home directory or you can create the bin directory n any folder you like e.g desktop, Downloads, Document. Just make sure you "cd" into the directory before running the commands below)

mkdir bin   # this creates /Users/kolapo/bin

After making the bin directory, you need to export the bin directory to PATH

cd into bin directory

cd Users/kolapo/bin   (Replace with the appropriate directory name for where you created your bin folder)

paste this code to the terminal and press enter: "export PATH=$PATH:/Users/kolapo/bin"  (Replace with yours)


Now lets create a script file and run it from the terminal to be sure Bash was installed correctly

Open your code editor (sublime text, notepad ++ e.t.c) create a new file and paste the code below inside

#!/bin/bash

echo Hello, World!


Please make sure to save the file inside the bin folder as "hello.sh"

Go back to your terminal and change the permission of the file created

$ chmod u+x hello.sh

Now run the file

$ hello.sh

if everything worked well, it should display "Hello, World!" on the terminal


##### MacOS:

MacOS comes with Bash by default, so all you have to do is create the bin directory, add it to environment PATH and create your first script file:

###### Follow the same procedure as windows from after installing Bash to the end, same applies for Bash on MacOS

NOTE: If you close your terminal and reopen it, you will need to add the bin directory to PATH again before running your scripts.

you can do this by "cd" to your bin directory, paste "export PATH=$PATH:/Users/kolapo/bin" and press Enter and your bin directory will be added to PATH. Now you can just type your script name (hello.sh) and Enter to run the script


#### Step 4 - AWS S3 Bucket
Go to your aws account, sign in and it will redirect you to the AWS Console. Go to Services and search "S3". Click on it and it will take you to the S3 service page.

On the S3 page, click "Create Bucket", Enter your desired bucket name (AWS Bucket Name are unique globally, so try to pick a bucket name no one else might already have), select US West (Oregon) as your region (!! This is very important as your S3 Bucket as to be in the same region with your cloud formation Stack), Skip "copy bucket settings from existing bucket" and click "Next"

Skip the Second page (Properties Page) and click Next to the Permissions page. On the permissions page, uncheck the "block all public access" option. This will prompt you to acknowledge that your bucket will be public. Click on the Acknowledgement and select Next. After that, click on create Bucket and the new bucket will be created. Please Copy out the name of the bucket created as it will be needed later.

Open the new bucket and click on "Upload". Download the pollyDocumentProcessor.zip file from this git to your computer and upload it to the S3 Bucket.

After this file has been uploaded, then you are ready to start creating your cloud Formation Stacks


#### Step 5 - VPC CLoudFormation Stack

The First stack to be created is the VPC stack. This stack creates a private VPC in your aws environment from where the AWS BAtch will work from.

To proceed, Download all files from this git into your bin directory created earlier.

Open your Bash terminal. if you are not inside your bin directory, "cd" into the bin directory and add the bin directory to PATH (Explained Previously).

The file to create the VPC stack is the "pollyvpc.sh" file. Before running it, we need to change the permission. Do that like this:

$ chmod u+x pollyvpc.sh (Enter)

Now run the script file

$ pollyvpc.sh

The script creates the VPC stack. Wait till you get this message "Successfully created/updated stack - pollyvpc". 

After getting this message, go back to your AWS Console, go to services and go to Cloud Formation. On the cloud formation page, you will see the stacks created. Click on polly vpc

When you click on Polly vpc, look for "Output" tab and on the output tabe, copy the values for VPC, PrivateSubnetOne and PrivateSubnetTwo to your a notepad. You will be needing this information to create the Audiobook Stack.



#### Step 6 - AudioBook CLoudFormation Stack

This stack create all the necessary services and needed IAM Roles necessary for the audiobook service to run in an automated fashion. To run this stack, you will need the following information handy as the terminal prompt will be asking for them

1. Code Bucket (The name of the S3 Bucket created Earlier)

2. VPC ID (The value for the VPC copied from the vpc stack)

3. Subnet 1 ID (The value for the PrivatesubnetOne copied from the vpc stack)

4. Subnet 2 ID (The value for the PrivatesubnetTwo copied from the vpc stack)

5. Email Address (An email address you can access where SNS notifications can be sent to).

After getting all the informations handy, go to the Terminal and we would be using the script "audiobook.sh" to create the stack. So just as we did earlier, we would be changing the permissions :


$ chmod u+x audiobook.sh (Enter)

Now run the script file

$ audiobook.sh

The script creates the Audiobook stack. When you run the script, it prompts you for the following:

##### hello, please enter your S3 Bucket where zip file resides : paste your code bucket name and press Enter

##### Please enter your VPC Id : paste your VPC ID value and press Enter

##### Please enter the first Subnet Id : paste your privatesubnetOne value and press Enter

##### Please enter the Second Subnet Id : paste your privatesubnetTwo value and press Enter

##### hello, please enter your email address for Notifications: paste your Email address and press Enter


After this, the script starts creating the audiobook stack. Wait till you get this message "Stack completed, please upload a text file to your s3 Bucket to start using the Service".

After this message, it shows that the audiobook stack has been deployed successfully. You can also confirm this by going to your aws console, cloud formation page and you should see the new "audiobook" stack


#### Step 7 - Using the AudioBook Service

Before uploading text file for synthensising, first go to your email address, you will have gotten an SNS Subscription email from AWS. Confirm the subscription.

Next go to the AWS console, S3 page. You will realise that a new S3 Bucket has been created and it should have the name structure : "Pollybatch-your aws account id-aws region". Open the bucket and click on "create folder". create a folder with folder name "books". After creating the folder, open the folder and upload your .txt file (file containing the text you want to change to audio) into the folder. Hurray you are Done!!

Wait for some minutes and you will get another email address from AWS telling you that your audiofile is ready and also a link to listen to it. Your Audio file will also have been saved to the same S3 Bucket inside an "Audio" folder.

You can create as many audiofiles as possible, just go into the books folder and upload your .txt file. 


#### Step 8 - Destroying Stack

If this was just a Proof-Of-Concept and you don't want to be charged by amazon concurrently for the services consumed by this Audiobook service, you can clean up and destroy the whole stack by running the "destroy_stack.sh" script file. You will be needing the name of the S3 bucket created by the audiobook stack (Pollybatch-your aws account id-aws region).

Go to your terminal and changing the permissions :


$ chmod u+x destroy_stack.sh (Enter)

Now run the script file

$ destroy_stack.sh

you will be prompted to enter the bucket name, paste the bucket name and press enter

Wait till you get the message "Stack Deleted" and all stacks used for the service provision would have been deleted. you can confirm by going to the CloudFormation page and you will see that the stacks are being deleted and also go to your S3 page and you will see that the bucket created by the Audiobook stack has also been deleted.

You can run the whole process all over again if you need the services again. 


### Having Issues while Creating the Services

you can contact me on kolapoobanewa@gmail.com and i would be glad to help you solve issues you might be having while using this Service

!! Have Fun

