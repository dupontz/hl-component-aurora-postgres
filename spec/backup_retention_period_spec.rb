require 'yaml'

describe 'compiled component aurora-postgres' do

  context 'cftest' do
    it 'compiles test' do
      expect(system("cfhighlander cftest #{@validate} --tests tests/backup_retention_period.test.yaml")).to be_truthy
    end
  end

  let(:template) { YAML.load_file("#{File.dirname(__FILE__)}/../out/tests/backup_retention_period/aurora-postgres.compiled.yaml") }

  context "Resource" do

    context "DBCluster" do
      let(:resource) { template["Resources"]["DBCluster"] }

      it "is of type AWS::RDS::DBCluster" do
          expect(resource["Type"]).to eq("AWS::RDS::DBCluster")
      end

      it "to have property BackupRetentionPeriod" do
          expect(resource["Properties"]["BackupRetentionPeriod"]).to eq(8)
      end

    end

  end

end
