subnetgroup-dev:
  boto_rds.subnet_group_present:
    - name: rds-subnet-dev
    - subnet_names:
        - subRdsA-dev
        - subRdsB-dev
        - subRdsC-dev
    - description: subnets for dev
    - region: us-west-2

rds-dev:
  boto_rds.present:
    - name: aws-rds-1
    - allocated_storage: 5
    - db_instance_class: db.t2.micro
    - engine: MySQL
    - master_username: admin
    - master_user_password: Beew5zai
    - db_name: appdb
    - storage_type: standard
    - vpc_security_group_ids:
        - sg-a89c59d2
    - availability_zone: us-west-2a
    - db_subnet_group_name: rds-subnet-dev
    - backup_retention_period: 0
    - port: 3306
    - multi_az: false
    - publicly_accessible: false
    - wait_status: available
    - region: us-west-2
