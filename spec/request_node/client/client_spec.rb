require 'spec_helper'

describe Ups::Client do

  
  describe '#initialize' do

    it "designates some parameters as required" do
      client = Ups::Client.new()
    
      expect(client.instance_variable_get(:"@required_attributes")).to eq [:name]
    end

    it "designates some parameters as optional" do
      client   = Ups::Client.new()
      optional = [:attention_name, :tax_id_number, :phone_number, :fax_number, :email_address] 
    
      expect(client.instance_variable_get(:"@optional_attributes")).to eq optional
    end

    it "turns acceptable parameters in to instance variables" do
      params = {
                name:           'Bartholomew Gubbins', 
                attention_name: 'Bart Gubbins', 
                tax_id_number:  '123456', 
                phone_number:   '5552129201', 
                fax_number:     '5552129202',
                email_address:  'bart@example.com'
      } 
      client = Ups::Client.new(params)    
      
      params.each do |k, v|
        expect(client.instance_variable_get(:"@#{k}")).to eq v
      end
    
    end

    it "ignores unacceptable parameters" do
      params = {
                name:           'Bartholomew Gubbins', 
                attention_name: 'Bart Gubbins', 
                tax_id_number:  '123456', 
                phone_number:   '5552129201', 
                fax_number:     '5552129202',
                email_address:  'bart@example.com',
                ringer: 'Ding Dong!'
      } 
      client = Ups::Client.new(params)    

      expect{ client.ringer }.to raise_error NoMethodError
      
    end
  
  end

  describe '#validate_required' do

    it 'raises an error if a required parameter is not present' do
      params = {
                attention_name: 'Bart Gubbins', 
                tax_id_number:  '123456', 
                phone_number:   '5552129201', 
                fax_number:     '5552129202',
                email_address:  'bart@example.com',
      } 
      client = Ups::Client.new(params)    
      expect{ client.send(:validate_required, params) }.to raise_error RuntimeError,  "Required attribute 'name' not set."
      
    end
    
  end



 end
