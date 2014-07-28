require 'spec_helper'

describe Ups::DeliveryConfirmation do

  describe '#initialize' do
    
    it "designates some parameters as required" do
      confirmation = Ups::DeliveryConfirmation.new({})
      expect(confirmation.instance_variable_get(:"@required_attributes")).to eq [:dcis_type]
    end

    it "designates some parameters as optional" do
      confirmation = Ups::DeliveryConfirmation.new({})
      optional     = [:dcis_number]
      
      expect(confirmation.instance_variable_get(:"@optional_attributes")).to eq optional
    end

    it "ignores unacceptable parameters" do
      params       = {dcis_type: 2,
                      dcis_number: 123456,
                      ringer: 'Ding Dong'}
      confirmation = Ups::DeliveryConfirmation.new(params)
      
      expect{ confirmation.ringer }.to raise_error NoMethodError
    end
    
  end

  describe '#validate_required' do

    it "raises an error if a required parameter is not present" do
      
      params       = { dcis_number: 123342 }
      confirmation = Ups::DeliveryConfirmation.new(params)    
      
      expect{ confirmation.send(:validate_required, params) }.to raise_error RuntimeError,  "Required attribute 'dcis_type' not set."
    end
    
  end

  describe '#to_xml' do
    
    let(:valid_opts){ return { dcis_type: 2 } }
    
    it "contains a /DeliveryConfirmation root node" do
      confirmation = Ups::DeliveryConfirmation.new(valid_opts)
      xml          = Nokogiri.XML(confirmation.to_xml)
      
      expect(xml.at('/DeliveryConfirmation')).to_not be_nil
    end

    it "contains required nodes and values" do
      confirmation = Ups::DeliveryConfirmation.new(valid_opts)
      xml          = Nokogiri.XML(confirmation.to_xml)
      
      expect(xml.at('/DeliveryConfirmation/DCISType').content).to eq valid_opts[:dcis_type].to_s
    end
 
    it "contains nodes for optional values" do
      
      confirmation  = Ups::DeliveryConfirmation.new(valid_opts.merge(dcis_number: 123456))      
      xml           = Nokogiri.XML(confirmation.to_xml)
      expect(xml.at('/DeliveryConfirmation/DCISNumber').content).to eq('123456')
    end

    it "does not contain nodes for values not passed" do
      confirmation  = Ups::DeliveryConfirmation.new(valid_opts)      
      xml           = Nokogiri.XML(confirmation.to_xml)
      expect(xml.at('/DeliveryConfirmation/DCISNUmber')).to be_nil
    end

  
  end


end
