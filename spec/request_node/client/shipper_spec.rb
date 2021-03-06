require 'spec_helper'

describe Ups::Shipper do

  describe '#initialize' do

    it 'validates required attributes' do
      expect{ Ups::Shipper.new({name: 'Johann Smithwick'}) }.to raise_error RuntimeError, "Required attribute 'shipper_number' not set."
    end
    
  end

  describe '#to_xml' do
    let(:valid_opts){ return {name: 'Johann Smithwick', shipper_number: '123456'} }
    
    it "contains a /Shipper root node" do
      shipper = Ups::Shipper.new(valid_opts)
      xml     = Nokogiri.XML(shipper.to_xml)
      
      expect(xml.at('/Shipper')).to_not be_nil
    end

    it "contains required nodes and values" do
      shipper = Ups::Shipper.new(valid_opts)
      xml     = Nokogiri.XML(shipper.to_xml)
      
      expect(xml.at('/Shipper/Name').content).to eq valid_opts[:name]
      expect(xml.at('/Shipper/ShipperNumber').content).to eq valid_opts[:shipper_number]
    end
 
    it "contains nodes for optional values" do
      extended_opts = {
        name: 'Johann Smithwick',
        attention_name: 'John Smith',
        shipper_number: '23456',
        tax_id_number: '123405',
        phone_number: '5551209291',
        fax_number: '5551209292',
        email_address: 'john@example.com',
      }
      shipper = Ups::Shipper.new(extended_opts)      
      xml     = Nokogiri.XML(shipper.to_xml)

      expect(xml.at('/Shipper/AttentionName').content).to eq extended_opts[:attention_name]
      expect(xml.at('/Shipper/TaxIdentificationNumber').content).to eq extended_opts[:tax_id_number]
      expect(xml.at('/Shipper/PhoneNumber').content).to eq extended_opts[:phone_number]
      expect(xml.at('/Shipper/FaxNumber').content).to eq extended_opts[:fax_number]
      expect(xml.at('/Shipper/EMailAddress').content).to eq extended_opts[:email_address]
    end

    it "does not contain nodes for values not passed" do
      shipper = Ups::Shipper.new(valid_opts)      
      xml     = Nokogiri.XML(shipper.to_xml)
      
      expect(xml.at('/Shipper/AttentionName')).to be_nil
      expect(xml.at('/Shipper/TaxIdentificationNumber')).to be_nil
      expect(xml.at('/Shipper/PhoneNumber')).to be_nil
      expect(xml.at('/Shipper/FaxNumber')).to be_nil
      expect(xml.at('/Shipper/EMailAddress')).to be_nil
    end

    it "contains an Address node when an Address object is passed" do
      address = Ups::Address.new({address_line1: '1 Bag End', city: 'Hobbiton', country_code: 'TS'})
      shipper = Ups::Shipper.new(valid_opts.merge(address: address))
      xml     = Nokogiri.XML(shipper.to_xml)

      expect(xml.at('/Shipper/Address').to_s).to eq address.to_xml()
    end

    it "contains a ShipFrom node when an Address object is passed as a ShipFrom address" do
      address = Ups::Address.new({address_line1: '1 Bag End', city: 'Hobbiton', country_code: 'TS'})
      shipper = Ups::Shipper.new(valid_opts.merge(ship_from: address))
      xml     = Nokogiri.XML(shipper.to_xml)

      expect(xml.at('/Shipper/ShipFrom').to_s).to eq address.to_xml('ShipFrom')
    end

    
  end



 end
