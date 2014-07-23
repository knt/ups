module Ups

  class RequestNode
  

    def initialize(options = {})
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
