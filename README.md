# aurora (Postgres) CfHighlander component
## Parameters

| Name | Use | Default | Global | Type | Allowed Values |
| ---- | --- | ------- | ------ | ---- | -------------- |
| EnvironmentName | Tagging | dev | true | string
| EnvironmentType | Tagging | development | true | string | ['development','production']
| VPCId | Security Groups | None | false | AWS::EC2::VPC::Id
| DnsDomain | DNS domain to use | None | true | string
| SubnetIds | List of subnets | None | false | CommaDelimitedList
| KmsKeyId | KMS ID | None | false | string (arn)
| NamespaceId | Service discovery namespace ID | None | false | string
| SnapshotId | Snapshot ID to provision from | None | false | string
| WriterInstanceType | Writer instance type *if engine is set to provisioned* | None | false | string
| ReaderInstanceType | Reader instance type *if engine is set to provisioned* | None | false | string
| StorageType | Cluster storage configuration. `aurora` is Aurora Standard, `aurora-iopt1` is Aurora I/O-Optimized. The `StorageType` property is only set on the DB cluster when `aurora-iopt1` is selected | aurora | false | string | ['aurora','aurora-iopt1']

### Storage Type

By default the `StorageType` property is omitted from the DB cluster, so existing clusters keep their current (Aurora Standard) storage configuration.
To opt into [Aurora I/O-Optimized](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Overview.StorageReliability.html#aurora-storage-type) set the `StorageType` parameter to `aurora-iopt1`:

```ruby
  Component name:'database', template: 'aurora-postgres' do
    parameter name: 'StorageType', value: 'aurora-iopt1'
  end
```

I/O-Optimized requires a supported engine version (Aurora PostgreSQL 13.10, 14.7, 15.2 and higher). Switching an existing cluster between storage types is an in-place modification, but AWS limits how often you can switch back to Aurora Standard (once every 30 days).

## Outputs/Exports

| Name | Value | Exported |
| ---- | ----- | -------- |
| SecurityGroup | Security Group name | true
| ServiceRegistry | CloudMap service registry ID | true
| DBClusterId | Database Cluster ID | true

## Included Components

[lib-ec2](https://github.com/theonestack/hl-component-lib-ec2)

## Example Configuration
### Highlander
```
  Component name:'database', template: 'aurora-postgres' do
    parameter name: 'DnsDomain', value: root_domain
    parameter name: 'DnsFormat', value: FnSub("${EnvironmentName}.#{root_domain}")
    parameter name: 'SubnetIds', value: cfout('vpcv2', 'PersistenceSubnets')
    parameter name: 'WriterInstanceType', value: writer_instance
    parameter name: 'ReaderInstanceType', value: reader_instance
    parameter name: 'EnableReader', value: 'true'
    parameter name: 'StackOctet', value: '80'
    parameter name: 'NamespaceId', value: cfout('servicediscovery', 'NamespaceId')
  end
```

### Aurora Postgres Configuration
```
hostname: db
database_name: appdb
dns_format: ${DnsFormat}

storage_encrypted: true
engine: aurora-postgres
engine_version: '13.4'

writer_instance: db.r3.large
reader_instance: db.r3.large

master_login: 
    username_ssm_param: /${EnvironmentName}/myapp/dbuser
    password_ssm_param: /${EnvironmentName}/myapp/dbpass

security_group:
  -
    rules:
      -
        IpProtocol: tcp
        FromPort: 5432
        ToPort: 5432
    ips:
      - stack
      - company_office
      - company_client_vpn

service_discovery:
  name: db
```

## Cfhighlander Setup

install cfhighlander [gem](https://github.com/theonestack/cfhighlander)

```bash
gem install cfhighlander
```

or via docker

```bash
docker pull theonestack/cfhighlander
```
## Testing Components

Running the tests

```bash
cfhighlander cftest aurora-postgres
```