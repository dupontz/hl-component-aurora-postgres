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

      it "is of type String" do
          expect(parameter["Type"]).to eq("String")
      end

      it "defaults to aurora" do
          expect(parameter["Default"]).to eq("aurora")
      end

      it "allows aurora and aurora-iopt1" do
          expect(parameter["AllowedValues"]).to eq(["aurora", "aurora-iopt1"])
      end

    end

  end

  context "Condition" do

    context "UseIOOptimizedStorage" do
      let(:condition) { template["Conditions"]["UseIOOptimizedStorage"] }

      it "is true only when StorageType is aurora-iopt1" do
          expect(condition).to eq({"Fn::Equals"=>[{"Ref"=>"StorageType"}, "aurora-iopt1"]})
      end

    end

  end

  context "Resource" do

    context "DBCluster" do
      let(:resource) { template["Resources"]["DBCluster"] }

      it "is of type AWS::RDS::DBCluster" do
          expect(resource["Type"]).to eq("AWS::RDS::DBCluster")
      end
      
      it "to have property EngineVersion" do
          expect(resource["Properties"]["EngineVersion"]).to eq(15.4)
      end
      
      it "to have property StorageType only set when I/O-Optimized is selected" do
          expect(resource["Properties"]["StorageType"]).to eq({"Fn::If"=>["UseIOOptimizedStorage", {"Ref"=>"StorageType"}, {"Ref"=>"AWS::NoValue"}]})
      end
      
    end
    
  end

end
