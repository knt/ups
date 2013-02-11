require 'spec_helper'

describe Ups::Shipper do

  let(:name) { "Gaius Baltar" }
  let(:shipper_number) { "1a2b3c"}
  let(:address) { double(:address) }
  before(:each) do
    address.stub(:to_xml).and_return("<Address></Address>")
  end

  let(:shipper) { build_shipper(name, shipper_number, address) }

  specify { shipper.name.should == name }
  specify { shipper.shipper_number.should == shipper_number }

  describe "#to_xml" do
    let(:xml) { Nokogiri.XML(shipper.to_xml) }
    it "builds xml with node /Shipper" do
      xml.at("/Shipper").should_not be_nil
    end

    it "builds xml with node /Shipper/Name set to name" do
      xml.at("/Shipper/Name").content.should == name
    end

    context "if options[:attention_name] is present" do
      let(:attention_name) { "ATTN: Gaius Baltar"}
      let(:options) { {:attention_name => attention_name} }
      let(:shipper) { build_shipper(name, shipper_number, address, options) }
      let(:xml) { Nokogiri.XML(shipper.to_xml) }

      it "sets /Shipper/AttentionName to attention_name" do
        xml.at("/Shipper/AttentionName").content.should == attention_name
      end
    end

    context "if options[:attention_name] is not present" do
      it "does not include node /Shipper/AttentionName" do
        xml.at("/Shipper/AttentionName").should be_nil
      end
    end

    it "sets node /Shipper/ShipperNumber to shipper number" do
      xml.at("/Shipper/ShipperNumber").content.should == shipper_number
    end

    context "if options[:tax_identification_number] is present" do
      let(:tax_identification_number) { "1234567891011" }
      let(:options) { {:tax_identification_number => tax_identification_number } }
      let(:shipper) { build_shipper(name, shipper_number, address, options) }
      let(:xml) { Nokogiri.XML(shipper.to_xml) }

      it "sets /Shipper/TaxIdentificationNumber to tax_identification_number" do
        xml.at("/Shipper/TaxIdentificationNumber").content.should == tax_identification_number
      end
    end

    context "if options[:tax_identification_number] is not present" do
      it "does not include node /Shipper/TaxIdentificationNumber" do
        xml.at("/Shipper/TaxIdentificationNumber").should be_nil
      end
    end

    context "if options[:phone_number] is present" do
      let(:phone_number) { "0001111111" }
      let(:options) { {:phone_number => phone_number } }
      let(:shipper) { build_shipper(name, shipper_number, address, options) }
      let(:xml) { Nokogiri.XML(shipper.to_xml) }

      it "sets /Shipper/PhoneNumber to phone_number" do
        xml.at("/Shipper/PhoneNumber").content.should == phone_number
      end
    end

    context "if options[:phone_number] is not present" do
      it "does not include node /Shipper/PhoneNumber" do
        xml.at("/Shipper/PhoneNumber").should be_nil
      end
    end

    context "if options[:fax_number] is present" do
      let(:fax_number) { "1101111111" }
      let(:options) { {:fax_number => fax_number } }
      let(:shipper) { build_shipper(name, shipper_number, address, options) }
      let(:xml) { Nokogiri.XML(shipper.to_xml) }

      it "sets /Shipper/FaxNumber to fax_number" do
        xml.at("/Shipper/FaxNumber").content.should == fax_number
      end
    end

    context "if options[:fax_number] is not present" do
      it "does not include node /Shipper/FaxNumber" do
        xml.at("/Shipper/FaxNumber").should be_nil
      end
    end

    context "if options[:email_address] is present" do
      let(:email_address) { "test@test.com" }
      let(:options) { {:email_address => email_address } }
      let(:shipper) { build_shipper(name, shipper_number, address, options) }
      let(:xml) { Nokogiri.XML(shipper.to_xml) }

      it "sets /Shipper/EMailAddress to email_address" do
        xml.at("/Shipper/EMailAddress").content.should == email_address
      end
    end

    context "if options[:email_address] is not present" do
      it "does not include node /Shipper/EMailAddress" do
        xml.at("/Shipper/EMailAddress").should be_nil
      end
    end

    it "includes address xml" do
      xml.at("/Shipper/Address").should_not be_nil
    end
  end

   def build_shipper(name, shipper_number, address, options={})
     Ups::Shipper.new(name, shipper_number, address, options)
   end
 end
