Gem::Specification.new do |s|
  s.name        = 'ups'
  s.version     = '0.0.0'
  s.platform    =	Gem::Platform::RUBY
  s.date        = '2012-12-22'
  s.summary     = "UPS Shipping Label Generator"
  s.description = "Interacts with the UPS Developer API to generate UPS shipping labels and shipments"
  s.authors     = ["Nichole Treadway"]
  s.email       = 'kntreadway@gmail.com'
  s.files       = ["lib/ups.rb"]
  s.homepage    = 'http://rubygems.org/gems/ups'
  s.required_ruby_version     = ">= 1.9.2"
  s.required_rubygems_version = ">= 1.3.6"
  s.add_dependency "nokogiri", "1.5.6"

  s.add_development_dependency "rspec"

  s.files =  Dir.glob("{lib,spec}/**/*")
  s.files += %w(Rakefile ups.gemspec)
	s.require_path = "lib"
end


  

  
  

  

  

  

  
