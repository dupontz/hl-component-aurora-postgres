CfhighlanderTemplate do

  Name 'aurora-postgres'

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
  end
  
end
