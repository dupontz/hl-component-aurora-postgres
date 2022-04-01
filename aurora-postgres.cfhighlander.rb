CfhighlanderTemplate do

  Name 'aurora-postgres'

  DependsOn 'lib-iam@0.2.0'

  Parameters do
    ComponentParam 'EnvironmentName', 'dev', isGlobal: true
    ComponentParam 'EnvironmentType', 'development', isGlobal: true, allowedValues: ['development', 'production']
    ComponentParam 'WriterInstanceType'
    ComponentParam 'ReaderInstanceType'
    ComponentParam 'DnsDomain'
    ComponentParam 'SnapshotID'
    ComponentParam 'EnableReader', 'false', allowedValues: ['true', 'false']
    ComponentParam 'VPCId', type: 'AWS::EC2::VPC::Id'
    ComponentParam 'SubnetIds', type: 'CommaDelimitedList'
    ComponentParam 'KmsKeyId' if (defined? kms) && (kms)

    ComponentParam 'NamespaceId' if defined? service_discovery
  end

end
