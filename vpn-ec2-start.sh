#to be run on my laptop


#Look up Amazon AMI_ID's at http://aws.amazon.com/amazon-linux-ami/ for region specifics, this assumes Oregon

# Uses region-specific amazon linux ami, switch at will
#AMI_ID=ami-d03ea1e0 #must be adapted to your region
AMI_ID=ami-ccf297fc # us-west-2 2013.12 release 
KEY_ID=devreviewui # alternate is dwhitlock-testing
SEC_ID=VPN
BOOTSTRAP_SCRIPT=vpn-ec2-install.sh 

echo "Starting Instance..."
INSTANCE_DETAILS=`$EC2_HOME/bin/ec2-run-instances $AMI_ID -k $KEY_ID -t t1.micro -g $SEC_ID -f $BOOTSTRAP_SCRIPT | grep INSTANCE`
echo $INSTANCE_DETAILS

AVAILABILITY_ZONE=`echo $INSTANCE_DETAILS | awk '{print $9}'`
INSTANCE_ID=`echo $INSTANCE_DETAILS | awk '{print $2}'`
echo $INSTANCE_ID > $HOME/vpn-ec2.id 

# wait for instance to be started
DNS_NAME=`$EC2_HOME/bin/ec2-describe-instances --filter "image-id=$AMI_ID" --filter "instance-state-name=running" | grep INSTANCE | awk '{print $4}'`

while [ -z "$DNS_NAME" ]
do
    echo "Waiting for instance to start...."
    sleep 5
    DNS_NAME=`$EC2_HOME/bin/ec2-describe-instances --filter "image-id=$AMI_ID" --filter "instance-state-name=running" | grep INSTANCE | awk '{print $4}'`
done

echo "Instance started"

echo "Instance ID = " $INSTANCE_ID
echo "DNS = " $DNS_NAME " in availability zone " $AVAILABILITY_ZONE


