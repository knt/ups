require 'spec_helper'

describe Ups::InsuredValue do

  describe '#initialize' do
    
    it "designates some parameters as required" do
      insured_value = Ups::InsuredValue.new({})
      expect(insured_value.instance_variable_get(:"@required_attributes")).to eq [:type_code]
    end

    it "designates some parameters as optional" do
      insured_value = Ups::InsuredValue.new({})
      optional     = [:type_description, :currency_code, :monetary_value]
      
      expect(insured_value.instance_variable_get(:"@optional_attributes")).to eq optional
    end

    it "ignores unacceptable parameters" do
      params       = {type_code: '01', ringer: 'Ding Dong'}
      insured_value = Ups::InsuredValue.new(params)
      
      expect{ insured_value.ringer }.to raise_error NoMethodError
    end
    
  end

  describe '#validate_required' do

    it "raises an error if a required parameter is not present" do
      
      params       = { type_description: 'Bogus' }
      insured_value = Ups::InsuredValue.new(params)    
      
      expect{ insured_value.send(:validate_required, params) }.to raise_error RuntimeError,  "Required attribute 'type_code' not set."
    end
    
  end

  describe '#to_xml' do
    
    let(:valid_opts){ return { type_code: '02' } }
    
    it "contains a /InsuredValue root node" do
      insured_value = Ups::InsuredValue.new(valid_opts)
      xml          = Nokogiri.XML(insured_value.to_xml)
      
      expect(xml.at('/InsuredValue')).to_not be_nil
    end

    it "contains required nodes and values" do
      insured_value = Ups::InsuredValue.new(valid_opts)
      xml          = Nokogiri.XML(insured_value.to_xml)
      
      expect(xml.at('/InsuredValue/Type/Code').content).to eq valid_opts[:type_code].to_s
    end
 
    it "contains nodes for optional values" do
      
      insured_value  = Ups::InsuredValue.new(valid_opts.merge({type_description: 'Bogus', currency_code: 'USD', monetary_value: '12.45'}))      
      xml           = Nokogiri.XML(insured_value.to_xml)
      expect(xml.at('/InsuredValue/Type/Description').content).to eq('Bogus')
      expect(xml.at('/InsuredValue/CurrencyCode').content).to eq('USD')
      expect(xml.at('/InsuredValue/MonetaryValue').content).to eq('12.45')
    end

    it "does not contain nodes for values not passed" do
      insured_value  = Ups::InsuredValue.new(valid_opts)      
      xml           = Nokogiri.XML(insured_value.to_xml)
      
      expect(xml.at('/InsuredValue/Type/Description')).to be_nil
      expect(xml.at('/InsuredValue/CurrencyCode')).to be_nil
      expect(xml.at('/InsuredValue/MonetaryValue')).to be_nil
    end

  
  end


end
