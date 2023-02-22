CfhighlanderTemplate do

  Name 'aurora-postgres'

  DependsOn 'lib-iam@0.2.0'

  Parameters do
    ComponentParam 'EnvironmentName', 'dev', isGlobal: true
    ComponentParam 'EnvironmentType', 'development', isGlobal: true, allowedValues: ['development', 'production']
    ComponentParam 'DnsDomain'
    ComponentParam 'SnapshotID'
    ComponentParam 'VPCId', type: 'AWS::EC2::VPC::Id'
    ComponentParam 'SubnetIds', type: 'CommaDelimitedList'
    ComponentParam 'KmsKeyId' if (defined? kms) && (kms)

    if defined?(engine_mode) && engine_mode == 'serverless'
      ComponentParam 'AutoPause', 'true', allowedValues: ['true', 'false']
      ComponentParam 'MaxCapacity', 2, allowedValues: [1, 2, 4, 8, 16, 32, 64, 128, 256]
      ComponentParam 'MinCapacity', 2, allowedValues: [1, 2, 4, 8, 16, 32, 64, 128, 256]
      ComponentParam 'SecondsUntilAutoPause', 3600
    else
      ComponentParam 'WriterInstanceType'
      ComponentParam 'ReaderInstanceType'
      ComponentParam 'EnableReader', 'false', allowedValues: ['true', 'false']
    end
    
    

    ComponentParam 'NamespaceId' if defined? service_discovery
  end

end
