#!/bin/bash

asg="nando-demo-20150408165215-NandoDemoWebASG-1FP2BAWBSDD32"
commitID="c2f1bf25ef1c26b6d61fa577889e0775f4526f53"

#aws deploy create-application --application-name nando-demo
aws iam create-role --role-name NandoDemoCodeDeployRole --assume-role-policy-document file://codedeploy/NandoDemoCodeDeployRole.json
aws iam put-role-policy --role-name NandoDemoCodeDeployRole --policy-name NandoDemoCodeDeployPolicy --policy-document file://codedeploy/NandoDemoCodeDeployPolicy.json
roleArn=$(aws iam get-role --role-name NandoDemoCodeDeployRole --query "Role.Arn" --output text)
aws deploy create-deployment-group --application-name nando-demo --deployment-group-name nando-demo --service-role-arn $roleArn --auto-scaling-group $asg
deployID=$(aws deploy create-deployment --application-name nando-demo  --github-location commitId=$commitID,repository=stelligent/nando_automation_demo --deployment-group-name nando-demo)
aws deploy get-deployment --deployment-id $deployID  --query "deploymentInfo.status" --output text