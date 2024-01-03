### Remote Backend ### 
# Created by Bermet #



##### This part of the project presents the creation of the S3 bucket and DynamoDB lock in AWS using Terraform. #####



1. Clone source code repository to your local machine and navigate to directory with terraform files:
```
- git clone https://github.com/bermetdaniel/liatrio.git/eks-tf
- cd remote_backend
```

2.  Review AWS Backend resources to be created by executing the command:
```
- make plan
```

3. To create all the resources and dependancies execute the next command:\
   
```
- make apply
```

4. To create everything by running one command:
```
- make all
```

5. To update everything after changes made:
```
- make update
```

6. To delete everything by rinning one command:
```
- make delete-all
```
