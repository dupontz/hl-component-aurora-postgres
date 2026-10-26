require 'yaml'

describe 'compiled component aurora-postgres' do

  context 'cftest' do
    it 'compiles test' do
      expect(system("cfhighlander cftest #{@validate} --tests tests/storage_type.test.yaml")).to be_truthy
    end
  end

  let(:template) { YAML.load_file("#{File.dirname(__FILE__)}/../out/tests/storage_type/aurora-postgres.compiled.yaml") }

  context "Parameter" do
    context "StorageType" do
      let(:parameter) { template["Parameters"]["StorageType"] }

      it "defaults to empty" do
        expect(parameter["Default"]).to eq("")
      end

      it "allows empty, aurora and aurora-iopt1" do
        expect(parameter["AllowedValues"]).to eq(["", "aurora", "aurora-iopt1"])
      end
    end
  end

  context "Condition" do
    context "SetStorageType" do
      it "is true when StorageType is not empty" do
        expect(template["Conditions"]["SetStorageType"]).to eq({"Fn::Not"=>[{"Fn::Equals"=>[{"Ref"=>"StorageType"}, ""]}]})
      end
    end
  end

  context "Resource" do
    context "DBCluster" do
      let(:resource) { template["Resources"]["DBCluster"] }

      it "is of type AWS::RDS::DBCluster" do
        expect(resource["Type"]).to eq("AWS::RDS::DBCluster")
      end

      it "to have property StorageType" do
        expect(resource["Properties"]["StorageType"]).to eq({"Fn::If"=>["SetStorageType", {"Ref"=>"StorageType"}, {"Ref"=>"AWS::NoValue"}]})
      end

      it "to have property EngineVersion" do
        expect(resource["Properties"]["EngineVersion"]).to eq("14.7")
      end
    end
  end

end
