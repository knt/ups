# TODO Clean this up using directory blobbing
require "ups/version"
require "ups/shipping_label/request/base"
require "ups/shipping_label/request/access_request"
require "ups/shipping_label/request/shipment_accept_request"
require "ups/shipping_label/request/void_shipment_request"
require "ups/shipping_label/request/shipment_confirm_request"
require 'ups/request_node/request_node'
require 'ups/request_node/client/client'
require "ups/request_node/client/shipper"
require "ups/request_node/client/consignee"
require "ups/request_node/address"
require "ups/request_node/package/package"
require "ups/request_node/package/package_dimensions"
require "ups/request_node/package/package_weight"
require "ups/request_node/package/packaging_type"
require "ups/request_node/package/reference_number"
require "ups/request_node/package_service_options/package_service_options"
require "ups/request_node/package_service_options/delivery_confirmation"
require "ups/request_node/package_service_options/insured_value"
require "ups/shipping_label/shipping_label_generator"

module Ups
end
