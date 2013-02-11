require 'spec_helper'

describe Ups::Shipper do

  let(:name) { "Gaius Baltar" }
  let(:shipper_number) { "1a2b3c"}
  let(:address) { double(:addres) }
  before(:each) do
    address.stub(:to_xml).and_return("<Address></Address>")
  end

  let(:shipper) { build_shipper(name, shipper_number, address) }

  specify { shipper.name.should == name }
  specify { shipper.shipper_number.should == shipper_number }

  context "if options[:attention_name] is present" do
    let(:attention_name) { "ATTN: Gaius Baltar"}
    let(:options) { {:attention_name => attention_name} }
    let(:shipper) { build_shipper(name, shipper_number, address, options) }

    it "sets attention_name" do
      shipper.attention_name.should == attention_name
    end
  end

  def build_shipper(name, shipper_number, address, options={})
    Ups::Shipper.new(name, shipper_number, address, options)
  end
end
