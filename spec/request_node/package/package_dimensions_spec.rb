require 'spec_helper'

describe Ups::PackageDimensions do

  describe '#initialize' do
    
    it "designates some parameters as required" do
      dimensions = Ups::PackageDimensions.new({})
      expect(dimensions.instance_variable_get(:"@required_attributes")).to eq [:length, :width, :height, :code]
    end

    it "designates no parameters as optional" do
      dimensions = Ups::PackageDimensions.new({})
      optional = [:address_line2, :address_line3, :state, :postal_code, :is_residential]
      params  = {address_line1: '123 Any Street', city: 'Any Town', country_code: 'US', ringer: 'Ding Dong'}
      address = Ups::Address.new(params)
      
      expect{ address.ringer }.to raise_error NoMethodError
      
      expect(dimensions.instance_variable_get(:"@optional_attributes")).to be_nil
    end

    it "ignores unacceptable parameters" do
      params     = {length: '84', width: '72', height: '45', code: 'IN', ringer: 'Ding Dong'}
      dimensions = Ups::PackageDimensions.new(params)
      
      expect{ dimensions.ringer }.to raise_error NoMethodError
    end
    
  end

  describe '#validate_required' do

    it "raises an error if a required parameter is not present" do
      params     = {length: '84', width: '72', height: '45'} 
      dimensions = Ups::PackageDimensions.new(params)    
      
      expect{ dimensions.send(:validate_required, params) }.to raise_error RuntimeError,  "Required attribute 'code' not set."
    end
    
  end

  describe '#to_xml' do
    let(:valid_opts){ return {length: '84', width: '72', height: '45', code: 'IN'} }
    
    it "contains a /Dimensions root node" do
      dimensions = Ups::PackageDimensions.new(valid_opts)
      xml        = Nokogiri.XML(dimensions.to_xml)
      
      expect(xml.at('/Dimensions')).to_not be_nil
    end

    it "contains required nodes and values" do
      dimensions = Ups::PackageDimensions.new(valid_opts)
      xml     = Nokogiri.XML(dimensions.to_xml)
      
      expect(xml.at('/Dimensions/Length').content).to eq valid_opts[:length]
      expect(xml.at('/Dimensions/Width').content).to eq valid_opts[:width]
      expect(xml.at('/Dimensions/Height').content).to eq valid_opts[:height]
      expect(xml.at('/Dimensions/UnitOfMeasurement/Code').content).to eq valid_opts[:code]
      expect(xml.at('/Dimensions/UnitOfMeasurement/Description').content).to eq Ups::PackageDimensions::DIMENSION_UNITS[valid_opts[:code]]
    end
  
  end


end
