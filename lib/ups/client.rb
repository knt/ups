module Ups

  class Client < RequestNode
    attr_accessor :name, :address, :shipper_number, :attention_name, :tax_id_number, :phone_number, :fax_number, :email_address, :location_id

    def initialize(options = {})
      @required_attributes = [:name]
      @optional_attributes = [:attention_name, :tax_id_number, :phone_number, :fax_number, :email_address]
      super(options)
    end


  
  
  
  end

end
