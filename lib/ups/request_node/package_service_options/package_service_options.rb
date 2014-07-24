module Ups
  class PackageServiceOptions < RequestNode
    attr_accessor :delivery_confirmation
                  
    
    def initialize(options = {})
      super(options)
    end


    def to_xml
      request = Nokogiri::XML::Builder.new do |xml|
          xml.PackageServiceOptions {
            xml << @delivery_confirmation.to_xml if @delivery_confirmation
            xml << @insured_value.to_xml if @insured_value
            #TODO /Package/PackageServiceOptions/COD/..
            #TODO /Package/PackageServiceOptions/VerbalConfirmation/..
            #TODO /Package/PackageServiceOptions/ShipperReleaseIndicator/..
            #TODO /Package/PackageServiceOptions/Notification/..
            #TODO /Package/PackageServiceOptions/ReturnsFlexibleAccessIndicator
            #TODO /Package/PackageServiceOptions/DryIce/..
          }
      end

      Nokogiri::XML(request.to_xml).root.to_xml
    end
  end
end
