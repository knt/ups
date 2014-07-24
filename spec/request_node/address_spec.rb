require 'spec_helper'

describe Ups::Address do

  describe '#initialize' do
    
    it "designates some parameters as required" do
      address = Ups::Address.new({})
      expect(address.instance_variable_get(:"@required_attributes")).to eq [:address_line1, :city, :country_code]
    end

    it "designates some parameters as optional" do
      address  = Ups::Address.new({})
      optional = [:address_line2, :address_line3, :state, :postal_code, :is_residential]
      
      expect(address.instance_variable_get(:"@optional_attributes")).to eq optional
    end

    it "ignores unacceptable parameters" do
      params  = {address_line1: '123 Any Street', city: 'Any Town', country_code: 'US', ringer: 'Ding Dong'}
      address = Ups::Address.new(params)
      
      expect{ address.ringer }.to raise_error NoMethodError
    end
    
  end

  describe '#validate_required' do

    it "raises an error if a required parameter is not present" do
      params  = {city: 'Any Town', country_code: 'US'} 
      address = Ups::Address.new(params)    
      
      expect{ address.send(:validate_required, params) }.to raise_error RuntimeError,  "Required attribute 'address_line1' not set."
    end
    
  end

  describe '#to_xml' do
    let(:address){ Address.new({}) }
    let(:valid_opts){ return {address_line1: '123 Any Street', city: 'Any Town', country_code: 'US'} }
    
    it "contains a /Address root node" do
      address = Ups::Address.new(valid_opts)
      xml     = Nokogiri.XML(address.to_xml)
      
      expect(xml.at('/Address')).to_not be_nil
    end

    it "contains required nodes and values" do
      address = Ups::Address.new(valid_opts)
      xml     = Nokogiri.XML(address.to_xml)
      
      expect(xml.at('/Address/AddressLine1').content).to eq valid_opts[:address_line1]
      expect(xml.at('/Address/City').content).to eq valid_opts[:city]
      expect(xml.at('/Address/CountryCode').content).to eq valid_opts[:country_code]
    end
 
    it "contains nodes for optional values" do
      extended_opts = {
        address_line1: '123 Any Street',
        address_line2: 'Ste. 231',
        address_line3: 'Door B',
        city: 'Any Town',
        state: 'CA',
        postal_code: '92121',
        country_code: 'US',
        is_residential: 'true'
      }
      address = Ups::Address.new(extended_opts)      
      xml     = Nokogiri.XML(address.to_xml)

      expect(xml.at('/Address/AddressLine2').content).to eq extended_opts[:address_line2]
      expect(xml.at('/Address/AddressLine3').content).to eq extended_opts[:address_line3]
      expect(xml.at('/Address/City').content).to eq extended_opts[:city]
      expect(xml.at('/Address/PostalCode').content).to eq extended_opts[:postal_code]
      expect(xml.at('/Address/StateProvinceCode').content).to eq extended_opts[:state]
      expect(xml.at('/Address/ResidentialAddress')).to_not be_nil
    end

    it "does not contain nodes for values not passed" do
      address = Ups::Address.new(valid_opts)      
      xml     = Nokogiri.XML(address.to_xml)
      
      expect(xml.at('/Address/AddressLine2')).to be_nil
      expect(xml.at('/Address/AddressLine3')).to be_nil
      expect(xml.at('/Address/PostalCode')).to be_nil
      expect(xml.at('/Address/State')).to be_nil
      expect(xml.at('/Address/ResidentialAddress')).to be_nil
    end

  
  end




end
