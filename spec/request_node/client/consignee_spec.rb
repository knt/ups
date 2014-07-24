require 'spec_helper'

describe Ups::Consignee do
  
  describe '#initialize' do

    it 'validates required attributes' do
      expect{ Ups::Consignee.new({name: 'Frodo Baggins'}) }.to raise_error RuntimeError, "Required attribute 'address' not set."
    end
    
  end

  describe '#to_xml' do
    let(:address){ Ups::Address.new({address_line1: '123 Any Street', city: 'Any Town', state: 'CA', country_code: 'US'}) }
    let(:valid_opts){ return {name: 'Samwise Gamgee', address: address} }
    
    it "contains a /ShipTo root node" do
      consignee = Ups::Consignee.new(valid_opts)
      xml       = Nokogiri.XML(consignee.to_xml)
      
      expect(xml.at('/ShipTo')).to_not be_nil
    end

    it "contains required nodes and values" do
      consignee = Ups::Consignee.new(valid_opts)
      xml       = Nokogiri.XML(consignee.to_xml)
      
      expect(xml.at('/ShipTo/CompanyName').content).to eq valid_opts[:name]
      expect(xml.at('/ShipTo/Address').to_s).to eq valid_opts[:address].to_xml
    end

    it "contains nodes for optional values" do
      extended_opts = {
        name: 'Frodo Baggins',
        attention_name: 'Frodo',
        tax_id_number: '12345',
        phone_number: '5552123021',
        fax_number: '5552123022',
        email_address: 'frodo@example.com',
        location_id: '9',
        address: address,
      }
      
      consignee = Ups::Consignee.new(extended_opts)      
      xml       = Nokogiri.XML(consignee.to_xml)

      expect(xml.at('/ShipTo/AttentionName').content).to eq extended_opts[:attention_name]
      expect(xml.at('/ShipTo/TaxIdentificationNumber').content).to eq extended_opts[:tax_id_number]
      expect(xml.at('/ShipTo/PhoneNumber').content).to eq extended_opts[:phone_number]
      expect(xml.at('/ShipTo/FaxNumber').content).to eq extended_opts[:fax_number]
      expect(xml.at('/ShipTo/EMailAddress').content).to eq extended_opts[:email_address]
      expect(xml.at('/ShipTo/LocationID').content).to eq extended_opts[:location_id]
    end

    it "does not contain nodes for values not passed" do
      consignee = Ups::Consignee.new(valid_opts)      
      xml       = Nokogiri.XML(consignee.to_xml)

      expect(xml.at('/ShipTo/AttentionName')).to be_nil 
      expect(xml.at('/ShipTo/TaxIdentificationNumber')).to be_nil
      expect(xml.at('/ShipTo/PhoneNumber')).to be_nil
      expect(xml.at('/ShipTo/FaxNumber')).to be_nil
      expect(xml.at('/ShipTo/EMailAddress')).to be_nil
      expect(xml.at('/ShipTo/LocationID')).to be_nil
    end
  
  end

end
