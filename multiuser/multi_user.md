# Adding a new user to a cluster 
A short guide how to add a new user with his own key to the cluster, based on https://github.com/aws/aws-parallelcluster/wiki/MultiUser-Support
1. Connect to the head node and execute following command to create a user on a head node (replace __newuser__ by username):
```
sudo useradd newuser
```
2. Create a file in the shared directory (assuming __/shared__) with the user's username and UID like so:
```
echo "newuser,`id -u newuser`" >> /shared/userlistfile
```

3. Transfer the __create_users.sh__ to your s3 bucket. You can do this manually or by executing the following command:
```
aws s3 cp create_users.sh s3://your_bucket/
```
4. Update your config file by adding the following lines in the [cluster] section:
```
[cluster clustername]
s3_read_resource = arn:aws:s3:::your_bucket/*
post_install = s3://your_bucket/create_users.sh
```
5. Transfer the user's public key and __the add_key.sh__ to the head node:
```   
scp -i /path/to/yourkey.pem  /path/to/userpublickey.pub your-instance-user-name@your-instance-public-dns-name:/path/to/destination

scp -i /path/to/yourkey.pem  /path/to/add_key.sh your-instance-user-name@your-instance-public-dns-name:/path/to/destination
```
__Optional__
To extract public key from .pem file use the following command:
```
ssh-keygen -y -f /path/to/newuser-key-pair.pem >> /path/to/newuser-public-key.pub
```
6. Connect to your head node and execute the following to attribute the public key to the user
```
chmod +x add-key.sh
sudo ./add-key.sh newuser newuser-public-key.pub
```
7. Make the bash shell default for newuser
```
sudo usermod --shell /bin/bash newuser
```

8. Now the user can connect to the cluster using the following command:
```
ssh -i /home/andrii/Documents/JuniorsPath/AWS/playground-cluster-testuser.pem testuser@ec2-18-118-55-248.us-east-2.compute.amazonaws.com
```


__IMPORTANT__ Even if there are no users, the empty /shared/userlistfile must exist, if not the worker nodes will fail.
