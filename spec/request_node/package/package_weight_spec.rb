require 'spec_helper'

describe Ups::PackageWeight do

  describe '#initialize' do
    
    it "designates some parameters as required" do
      package_weight = Ups::PackageWeight.new({})
      expect(package_weight.instance_variable_get(:"@required_attributes")).to eq [:weight, :code]
    end

    it "ignores unacceptable parameters" do
      params         = {weight: '30', code: 'LBS', ringer: 'Ding Dong'}
      package_weight = Ups::PackageWeight.new(params)
      
      expect{ package_weight.ringer }.to raise_error NoMethodError
    end
    
  end

  describe '#validate_required' do

    it "raises an error if a required parameter is not present" do
      package_weight = Ups::PackageWeight.new()    
      
      expect{ package_weight.send(:validate_required, {code: 'LBS'}) }.to raise_error RuntimeError,  "Required attribute 'weight' not set."
    end
    
  end

  describe '#to_xml' do
    let(:valid_opts){ return {weight: '30', code: 'LBS'} }
    
    it "contains a /PackageWeight root node" do
      package_weight = Ups::PackageWeight.new(valid_opts)
      xml            = Nokogiri.XML(package_weight.to_xml)
      
      expect(xml.at('/PackageWeight')).to_not be_nil
    end

    it "contains required nodes and values" do
      package_weight = Ups::PackageWeight.new(valid_opts)
      xml            = Nokogiri.XML(package_weight.to_xml)
      
      expect(xml.at('/PackageWeight/Weight').content).to eq valid_opts[:weight]
      expect(xml.at('/PackageWeight/UnitOfMeasurement/Code').content).to eq valid_opts[:code]
      expect(xml.at('/PackageWeight/UnitOfMeasurement/Description').content).to eq Ups::PackageWeight::WEIGHT_UNITS[valid_opts[:code]]
    end
  
  end


end
