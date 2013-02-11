require 'spec_helper'

describe Ups::ShippingLabel::Request::Base do

	describe "#node_for_transaction_reference" do
		let(:base) { Ups::ShippingLabel::Request::Base.new }
		let(:customer_context) { "test_customer_context"}
		let (:transaction_reference_xml) { Nokogiri.XML(base.node_for_transaction_reference(customer_context)) }

		it "builds xml with TransactionReference node" do
			transaction_reference_xml.at('/TransactionReference').should_not be_nil
		end

		it "builds xml with /TransactionReference/CustomerContext node set to customer_context" do
			transaction_reference_xml.at('/TransactionReference/CustomerContext').content.should == customer_context
		end

		it "builds xml with /TransactionReference/XpciVersion node set to XPCI_VERSION" do
			transaction_reference_xml.at('/TransactionReference/XpciVersion').content.should == Ups::ShippingLabel::Request::Base::XPCI_VERSION
		end
	end
end