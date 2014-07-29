require 'spec_helper'

describe Ups::PackagingType do

  describe '#initialize' do
    
    it "designates some parameters as required" do
      packaging_type = Ups::PackagingType.new({})
      required       = [:code]
      expect(packaging_type.instance_variable_get(:"@required_attributes")).to eq required
    end

    it "ignores unacceptable parameters" do
      params         = {code: '01', ringer: 'Ding Dong'}
      packaging_type = Ups::PackagingType.new(params)
      
      expect{ packaging_type.ringer }.to raise_error NoMethodError
    end
    
  end

  describe '#validate_required' do

    it "raises an error if a required parameter is not present" do
      packaging_type = Ups::PackagingType.new()    
      
      expect{ packaging_type.send(:validate_required, {}) }.to raise_error RuntimeError,  "Required attribute 'code' not set."
    end
    
  end

  describe '#to_xml' do
    let(:valid_opts){ return {code: '01'} }
    
    it "contains a /PackagingType root node" do
      packaging_type = Ups::PackagingType.new(valid_opts)
      xml            = Nokogiri.XML(packaging_type.to_xml)
      
      expect(xml.at('/PackagingType')).to_not be_nil
    end

    it "contains required nodes and values" do
      packaging_type = Ups::PackagingType.new(valid_opts)
      xml            = Nokogiri.XML(packaging_type.to_xml)
      
      expect(xml.at('/PackagingType/Code').content).to eq valid_opts[:code]
      expect(xml.at('/PackagingType/Description').content).to eq Ups::PackagingType::PACKAGING_TYPES[valid_opts[:code]]
    end
  
  end


end
