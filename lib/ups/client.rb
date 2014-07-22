module Ups

  class Client
    attr_accessor :name, :address, :shipper_number, :attention_name, :tax_id_number, :phone_number, :fax_number, :email_address, :location_id

    def initialize(options = {})
      @required_attributes = [:name]
      @optional_attributes = [:attention_name, :tax_id_number, :phone_number, :fax_number, :email_address]

      options.each do |k, v|
        # the option becomes an instance variable if we have an accessor for it
        self.instance_variable_set("@#{k}", v) if self.respond_to?("#{k}=")
      end
    end


    private

      def validate_required(options)
        @required_attributes.each do |att|
          raise "Required attribute '#{att}' not set." unless options[att] && !options[att].empty?
        end
      end
  
  
  
  end

end
