#!/bin/bash
echo hello, please enter your S3 Bucket created by the audibook stack

read code_bucket

aws s3 rb s3://"$code_bucket" --force

aws ecr delete-repository --force --repository-name polly_document_processor

aws cloudformation delete-stack --stack-name myAudioBook

aws cloudformation delete-stack --stack-name pollyvpc

echo Stack Deleted