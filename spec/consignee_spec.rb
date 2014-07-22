require 'spec_helper'

describe Ups::Consignee do
  
  describe '#initialize' do

    it 'validates required attributes' do
      expect{ Ups::Consignee.new({name: 'Johann Smithwick'}) }.to raise_error RuntimeError, "Required attribute 'shipper_number' not set."
    end
    
  end

  describe '#to_xml' do
    let(:address){ Address.new({}) }
    let(:valid_opts){ return {name: 'Johann Smithwick', address: '123456'} }
    
    it "contains a /ShippTo root node" do
    end

    it "contains required nodes and values" do
    end
 
    it "contains nodes for optional values" do
    end

    it "does not contain nodes for values not passed" do
    end

    it "contains an Address node when an Address object is passed" do
      pending "Clean up the Address class first" 
      return false
    end

    it "contains a ShipFrom node when an Address object is passed as a ShipFrom address" do
      pending "Clean up the Address class first" 
      return false
    end

end
