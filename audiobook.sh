#!/bin/bash

echo hello, please enter your S3 Bucket where zip file resides

read code_bucket

echo Please enter your VPC Id

read vpc

echo Please enter the first Subnet Id

read subnet_1

echo Please enter the Second Subnet Id

read subnet_2

echo hello, please enter your email address for Notifications

read email

aws cloudformation deploy --template-file audiobook.json --stack-name myAudioBook --parameter-overrides EmailAddress="$email" VPC="$vpc" CodeBucket="$code_bucket" PrivateSubnets="$subnet_1,$subnet_2" --capabilities CAPABILITY_IAM

echo "Stack completed, please upload a text file to your s3 Bucket to start using the Service"


