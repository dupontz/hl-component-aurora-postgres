require 'yaml'

describe 'compiled component aurora-postgres' do

  context 'cftest' do
    it 'compiles test' do
      expect(system("cfhighlander cftest #{@validate} --tests tests/deletion_protection.test.yaml")).to be_truthy
    end
  end

  let(:template) { YAML.load_file("#{File.dirname(__FILE__)}/../out/tests/deletion_protection/aurora-postgres.compiled.yaml") }

  context "Parameter" do

    context "DeletionProtection" do
      let(:parameter) { template["Parameters"]["DeletionProtection"] }

      it "is of type String" do
          expect(parameter["Type"]).to eq("String")
      end

      it "defaults to false" do
          expect(parameter["Default"]).to eq("false")
      end

      it "allows true and false" do
          expect(parameter["AllowedValues"]).to eq(["true", "false"])
      end

    end

  end

  context "Resource" do

    context "DBCluster" do
      let(:resource) { template["Resources"]["DBCluster"] }

      it "to have property DeletionProtection" do
          expect(resource["Properties"]["DeletionProtection"]).to eq({"Ref"=>"DeletionProtection"})
      end

    end

  end

end
