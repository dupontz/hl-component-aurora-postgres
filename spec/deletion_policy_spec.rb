require 'yaml'

describe 'compiled component aurora-postgres' do

  context 'cftest' do
    it 'compiles test' do
      expect(system("cfhighlander cftest #{@validate} --tests tests/deletion_policy.test.yaml")).to be_truthy
    end
  end

  let(:template) { YAML.load_file("#{File.dirname(__FILE__)}/../out/tests/deletion_policy/aurora-postgres.compiled.yaml") }

  context "Resource" do

    context "DBCluster" do
      let(:resource) { template["Resources"]["DBCluster"] }

      it "is of type AWS::RDS::DBCluster" do
          expect(resource["Type"]).to eq("AWS::RDS::DBCluster")
      end

      it "to have DeletionPolicy" do
          expect(resource["DeletionPolicy"]).to eq("Delete")
      end

      it "to have UpdateReplacePolicy" do
          expect(resource["UpdateReplacePolicy"]).to eq("Delete")
      end

    end

  end

end
