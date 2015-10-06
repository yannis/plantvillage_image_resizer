# Upload an archived directory of images to PlantVillage

- create a basic EC2 instance (Amazon Linux AMI 2015.09 (HVM), SSD Volume Type)
    - it has 8GB of storage, Python, Ruby (v2.0.0) and the aws CLI
    - create a aws profile to access S3 and manage your files:
    ```$ aws configure --profile pvillage-dev```
- [Connect to EC2 via ssh](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html#AccessingInstancesLinuxSSHClient)
    - chmod your .pem key file to make it private:
    ```$ chmod 400 my-key-pair.pem```
    ```$ ssh -i my-key-pair.pem ec2-user@my-public-dns-key```
    - install ImageMagick:
    ```yum install ImageMagick-devel ImageMagick```
    - install ruby-devel:
    ```$ yum install ruby-devel```
    - install c compiler
    ```$ sudo yum groupinstall "Development Tools"```
    - install base gems:
    ```gem install io-console```
    ```gem install bundler```
    - clone resize repo:
    ```git clone https://github.com/yannis/plantvillage_image_resizer.git```

- use FileZilla to upload the file to your archive
    - open FileZilla
    - Go to the FileZilla settings, and on the left, click SFTP
    - Add your .pem key to access EC2
    - In the top fields, enter:
        - your EC2 Public DNS as the host
        - ec2-user as the user
        - 22 as the port
        - nothing as password
    - click Quickconnect
    - upload your file in an 'uploads' directory

- Unzip and resize your files:
```
$ irb
$ require 'unzip_and_resize'
$ uzr = UnzipAndResize.new('uploads')
$ uzr.run
```

- Unzip your archive:
```$ unzip name-of-dir.zip```
- Transfer your files to an S3 bucket accessible by your profile
```$ aws s3 sync plantvillage45 s3://plantimages-tmp-dir --profile pvillage-dev```
