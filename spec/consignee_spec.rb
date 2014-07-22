require 'spec_helper'

describe Ups::ShipTo do

  let(:company_name) { "Test Company"}
  let(:address) { double(:address) }
  let(:address_xml) { "<Address></Address>" }
  let(:options) { {} }
  let(:ship_to) { Ups::ShipTo.new(company_name, address, options)}
  before(:each) {
    address.stub(:to_xml).and_return(address_xml)
  }

  describe "#to_xml" do
    let (:xml) { Nokogiri.XML(ship_to.to_xml) }

    it "builds xml with ShipTo node" do
      xml.at("/ShipTo").should_not be_nil
    end

    it "builds xml with /ShipTo/CompanyName set to company_name" do
      xml.at("/ShipTo/CompanyName").content.should == company_name
    end

    context "if options[:attention_name] is present" do
      let(:attention_name) { "ATTN: Attention Name"}
      let(:options) { {:attention_name => attention_name }}
      let (:xml) { Nokogiri.XML(ship_to.to_xml) }

      it "sets AttentionName node to attention_name" do
        xml.at('/ShipTo/AttentionName').content.should == attention_name
      end
    end

    context "if options[:attention_name] is not present" do
      it "does not include AttentionName node" do
        xml.at('/ShipTo/AttentionName').should be_nil
      end
    end

    context "if options[:tax_identification_number] is present" do
      let(:tax_identification_number) { "123456789tax_id"}
      let(:options) { {:tax_identification_number => tax_identification_number }}
      let (:xml) { Nokogiri.XML(ship_to.to_xml) }

      it "sets TaxIdentificationNumber node to tax_identification_number" do
        xml.at('/ShipTo/TaxIdentificationNumber').content.should == tax_identification_number
      end
    end

    context "if options[:tax_identification_number] is not present" do
      it "does not include TaxIdentificationNumber node" do
        xml.at('/ShipTo/TaxIdentificationNumber').should be_nil
      end
    end

    context "if options[:phone_number] is present" do
      let(:phone_number) { "2220002222"}
      let(:options) { {:phone_number => phone_number }}
      let (:xml) { Nokogiri.XML(ship_to.to_xml) }

      it "sets PhoneNumber node to phone_number" do
        xml.at('/ShipTo/PhoneNumber').content.should == phone_number
      end
    end

    context "if options[:phone_number] is not present" do
      it "does not include PhoneNumber node" do
        xml.at('/ShipTo/PhoneNumber').should be_nil
      end
    end

    context "if options[:fax_number] is present" do
      let(:fax_number) { "2221112222"}
      let(:options) { {:fax_number => fax_number }}
      let (:xml) { Nokogiri.XML(ship_to.to_xml) }

      it "sets FaxNumber node to fax_number" do
        xml.at('/ShipTo/FaxNumber').content.should == fax_number
      end
    end

    context "if options[:fax_number] is not present" do
      it "does not include FaxNumber node" do
        xml.at('/ShipTo/FaxNumber').should be_nil
      end
    end

    context "if options[:email_address] is present" do
      let(:email_address) { "test_email@test.com"}
      let(:options) { {:email_address => email_address }}
      let (:xml) { Nokogiri.XML(ship_to.to_xml) }

      it "sets EMailAddress node to email_address" do
        xml.at('/ShipTo/EMailAddress').content.should == email_address
      end
    end

    context "if options[:email_address] is not present" do
      it "does not include EMailAddress node" do
        xml.at('/ShipTo/EMailAddress').should be_nil
      end
    end

    it "includes address xml" do
      xml.at('/ShipTo/Address').should_not be_nil
    end

    context "if options[:location_id] is present" do
      let(:location_id) { "location_id1234"}
      let(:options) { {:location_id => location_id }}
      let (:xml) { Nokogiri.XML(ship_to.to_xml) }

      it "sets LocationID node to location_id" do
        xml.at('/ShipTo/LocationID').content.should == location_id
      end
    end

    context "if options[:location_id] is not present" do
      it "does not include LocationID node" do
        xml.at('/ShipTo/LocationID').should be_nil
      end
    end
  end
end