module Ups
  
  class InsuredValue < RequestNode
    attr_accessor :type_code, :type_description, :currency_code, :monetary_value

    
    def initialize(options = {})
      super(options)
      @required_attributes = [:type_code]
      @optional_attributes = [:type_description, :currency_code, :monetary_value]
    end

    def to_xml
      
      request = Nokogiri::XML::Builder.new do |xml|

        xml.InsuredValue{
          xml.CurrencyCode @currency_code if @currency_code
          xml.MonetaryValue @monetary_value if @monetary_value
          
          if @type_code
            xml.Type{
              xml.Code @type_code  # 01 EVS or 02 DVS Defaults to 01
              xml.Description @type_description if @type_description
            }
          end
          
        }
      
      end
      
      Nokogiri::XML(request.to_xml).root.to_xml
    end


  end
end
