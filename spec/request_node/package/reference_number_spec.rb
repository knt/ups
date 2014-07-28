require 'spec_helper'

describe Ups::ReferenceNumber do

  describe '#initialize' do
    
    it "designates some parameters as required" do
      reference_number = Ups::ReferenceNumber.new({})
      attributes       = [:type_code, :value]
      expect(reference_number.instance_variable_get(:"@required_attributes")).to eq attributes
    end

    it "designates some parameters as optional" do
      reference_number = Ups::ReferenceNumber.new({})
      optional         = [:barcode]
      
      expect(reference_number.instance_variable_get(:"@optional_attributes")).to eq optional
    end

    it "ignores unacceptable parameters" do
      params           = {type_code: 'SE', value: '27008209834i328289',  ringer: 'Ding Dong'}
      reference_number = Ups::ReferenceNumber.new(params)
      
      expect{ reference_number.ringer }.to raise_error NoMethodError
    end
    
  end

  describe '#validate_required' do

    it "raises an error if a required parameter is not present" do
      params           = {type_code: 'SE'} 
      reference_number = Ups::ReferenceNumber.new(params)    
      
      expect{ reference_number.send(:validate_required, params) }.to raise_error RuntimeError,  "Required attribute 'value' not set."
    end
    
  end

  describe '#to_xml' do
    let(:valid_opts){ return {type_code: 'SE', value: '27008209834i328289'} }
    
    it "contains a /ReferenceNumber root node" do
      reference_number = Ups::ReferenceNumber.new(valid_opts)
      xml     = Nokogiri.XML(reference_number.to_xml)
      
      expect(xml.at('/ReferenceNumber')).to_not be_nil
    end

    it "contains required nodes and values" do
      reference_number = Ups::ReferenceNumber.new(valid_opts)
      xml              = Nokogiri.XML(reference_number.to_xml)
      
      expect(xml.at('/ReferenceNumber/Code').content).to eq valid_opts[:type_code]
      expect(xml.at('/ReferenceNumber/Value').content).to eq valid_opts[:value]
    end
 
    it "contains nodes for optional values" do
      extended_opts    = {barcode: true}
      reference_number = Ups::ReferenceNumber.new(valid_opts.merge({barcode: true}))      
      xml              = Nokogiri.XML(reference_number.to_xml)

      expect(xml.at('/ReferenceNumber/BarCodeIndicator').content).to_not be_nil
    end

    it "does not contain nodes for values not passed" do
      reference_number = Ups::ReferenceNumber.new(valid_opts)      
      xml              = Nokogiri.XML(reference_number.to_xml)

      expect(xml.at('/ReferenceNumber/BarCodeIndicator')).to be_nil
    end

  
  end


end
