module Ups

  class PackageDimensions < RequestNode

    DIMENSION_UNITS = {
      "IN" => "Inches",
      "CM" => "Centimeters",
      "00" => "Metric Units Of Measurement",
      "01" => "English Units of Measurement"
    }

    attr_accessor :length, :width, :height, :code 

    def initialize(options = {})
      @required_attributes = [:length, :width, :height, :code]
      super(options)
    end

    def to_xml
      request = Nokogiri::XML::Builder.new do |xml|
        
        xml.Dimensions{
          xml.UnitOfMeasurement {
            xml.Code @code
            xml.Description DIMENSION_UNITS[@code]
          }

          xml.Length @length
          xml.Width  @width
          xml.Height @height
        }
      
      end
    end
  
  
  end

end
