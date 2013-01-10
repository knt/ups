require 'spec_helper'

describe Ups::Address do

  let(:address_line1) { "123 Test Street" }
  let(:city) { "Boston"}
  let (:country_code) { "US"}
  let(:address) { build_address(address_line1, city, country_code) }

  specify { address.address_line1.should == address_line1 }
  specify { address.city.should == city }

  context "if options[:address_line2] is present" do
    let(:address_line2) { "Suite 200"}
    let(:options) { {:address_line2 => address_line2} }
    let(:address) { build_address(address_line1, city, country_code, options) }

    it "sets address_line2" do
      address.address_line2.should == address_line2
    end
  end

  context "if options[:address_line3] is present" do
    let(:address_line3) { "Dept of Stuff"}
    let(:options) { {:address_line3 => address_line3} }
    let(:address) { build_address(address_line1, city, country_code, options) }

    it "sets address_line3" do
      address.address_line3.should == address_line3
    end
  end

  context "if options[:state_province] is present" do
    let(:state_province) { "MA"}
    let(:options) { {:state_province => state_province} }
    let(:address) { build_address(address_line1, city, country_code, options)}

    it "sets state_province" do
      address.state_province.should == state_province
    end
  end

  context "if options[:postal_code] is present" do
    let(:postal_code) { "02139"}
    let(:options) { {:postal_code => postal_code} }
    let(:address) { build_address(address_line1, city, country_code, options) }

    it "sets postal_code" do
      address.postal_code.should == postal_code
    end
  end

  context "if options[:is_residential] is present" do
    let(:is_residential) { true }
    let(:options) { {:is_residential => is_residential}}
    let(:address) { build_address(address_line1, city, country_code, options) }

    it "sets is_residential" do
      address.is_residential.should == is_residential
    end
  end

  describe "#to_xml" do
    let(:xml) { Nokogiri.XML(address.to_xml) }

    it "builds xml with Address node" do
      xml.at('/Address').should_not be_nil
    end

    it "builds xml with AddressLine1 node set to address_line_1" do
      xml.at('/Address/AddressLine1').content.should == address_line1
    end

    it "builds xml with City node set to city" do
      xml.at('/Address/City').content.should == city
    end

    it "builds xml with CountryCode node set to country_code" do
      xml.at('/Address/CountryCode').content.should == country_code
    end

    context "if address.address_line2 is not nil" do
      let (:address_line2) { "Apt 1"}
      it "builds xml with AddressLine2 node set to address_line2" do
        address.address_line2 = address_line2
        xml = Nokogiri.XML(address.to_xml)

        xml.at('/Address/AddressLine2').content.should == address_line2
      end
    end

    context "if address.address_line2 is nil" do
      it "builds xml without AddressLine2" do
        address.address_line2 = nil
        xml = Nokogiri.XML(address.to_xml)

        xml.at('/Address/AddressLine2').should be_nil
      end
    end

    context "if address.address_line3 is not nil" do
      let(:address_line3) { "Suite 200"}
      it "builds xml with AddressLine3 node set to address_line3" do
        address.address_line3 = address_line3
        xml = Nokogiri.XML(address.to_xml)

        xml.at('/Address/AddressLine3').content.should == address_line3
      end
    end

    context "if address.address_line3 is nil" do
      it "builds xml without AddressLine3 node" do
        address.address_line3 = nil
        xml = Nokogiri.XML(address.to_xml)

        xml.at('/Address/AddressLine3').should be_nil
      end
    end

    context "if address.state_province is not nil" do
      let(:state_province) { "VA"}
      it "builds xml with StateProvinceCode node set to state_province" do
        address.state_province = state_province
        xml = Nokogiri.XML(address.to_xml)

        xml.at('/Address/StateProvinceCode').content.should == state_province
      end
    end

    context "if address.state_province is nil" do
      it "builds xml without StateProvinceCode node" do
        address.state_province = nil
        xml = Nokogiri.XML(address.to_xml)

        xml.at('/Address/StateProvinceCode').should be_nil
      end
    end

    context "if address.postal_code is not nil" do
      let(:postal_code) { "20009"}
      it "builds xml with PostalCode node set to postal code" do
        address.postal_code = postal_code
        xml = Nokogiri.XML(address.to_xml)

        xml.at('/Address/PostalCode').content.should == postal_code
      end
    end

    context "if address.postal_code is nil" do
      it "builds xml without PostalCode node" do
        address.postal_code = nil
        xml = Nokogiri.XML(address.to_xml)

        xml.at('/Address/PostalCode').should be_nil
      end
    end

    context "if address.is_residential is not nil" do
      it "builds xml with ResidentialAddress node" do
        address.is_residential = true
        xml = Nokogiri.XML(address.to_xml)

        xml.at('/Address/ResidentialAddress').should_not be_nil
      end
    end

    context "if address.is_residential is nil" do
      it "builds xml without ResidentialAddress node" do
        address.is_residential = nil
        xml = Nokogiri.XML(address.to_xml)

        xml.at('/Address/ResidentialAddress').should be_nil
      end
    end
  end

  def build_address(address_line1, city, country_code, options={})
    Ups::Address.new(address_line1, city, country_code, options)
  end
end
