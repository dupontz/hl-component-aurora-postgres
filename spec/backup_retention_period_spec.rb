require 'yaml'

describe 'compiled component aurora-postgres' do

  context 'cftest' do
    it 'compiles test' do
      expect(system("cfhighlander cftest #{@validate} --tests tests/backup_retention_period.test.yaml")).to be_truthy
    end
  end

  let(:template) { YAML.load_file("#{File.dirname(__FILE__)}/../out/tests/backup_retention_period/aurora-postgres.compiled.yaml") }

  context "Parameter" do

    context "BackupRetentionPeriod" do
      let(:parameter) { template["Parameters"]["BackupRetentionPeriod"] }

      it "is of type Number" do
          expect(parameter["Type"]).to eq("Number")
      end

      it "defaults to 1" do
          expect(parameter["Default"]).to eq(1).or eq("1")
      end

      it "allows 1 to 35 days" do
          expect(parameter["MinValue"]).to eq(1)
          expect(parameter["MaxValue"]).to eq(35)
      end

    end

  end

  context "Resource" do

    context "DBCluster" do
      let(:resource) { template["Resources"]["DBCluster"] }

      it "is of type AWS::RDS::DBCluster" do
          expect(resource["Type"]).to eq("AWS::RDS::DBCluster")
      end

      it "to have property BackupRetentionPeriod" do
          expect(resource["Properties"]["BackupRetentionPeriod"]).to eq({"Ref"=>"BackupRetentionPeriod"})
      end

    end

  end

end
