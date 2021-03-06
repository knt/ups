require 'spec_helper'

describe Ups::ShippingLabel::Request::Base do

	describe "#node_for_transaction_reference" do
		let(:base) { Ups::ShippingLabel::Request::Base.new }
		let(:customer_context) { "test_customer_context"}
		let (:transaction_reference_xml) { Nokogiri.XML(base.node_for_transaction_reference(customer_context)) }

		it "builds xml with TransactionReference node" do
			expect(transaction_reference_xml.at('/TransactionReference').content).not_to be_nil
		end

		it "builds xml with /TransactionReference/CustomerContext node set to customer_context" do
			expect(transaction_reference_xml.at('/TransactionReference/CustomerContext').content).to eq(customer_context)
		end

		it "builds xml with /TransactionReference/XpciVersion node set to XPCI_VERSION" do
			expect(transaction_reference_xml.at('/TransactionReference/XpciVersion').content).to eq(Ups::ShippingLabel::Request::Base::XPCI_VERSION)
		end
	end
end