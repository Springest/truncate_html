# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "nokogiri_truncate_html"
  gem.version       = '0.0.3'
  gem.authors       = ["Ian White", "Derek Kraan"]
  gem.email         = ["derek@springest.com"]
  gem.description   = %q{truncate_html helper that is html and html entities friendly}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/Springest/truncate_html"

  gem.files         = ['lib/nokogiri_truncate_html/truncate_html_helper.rb', 'lib/nokogiri_truncate_html/truncate_document.rb', 'lib/nokogiri_truncate_html.rb'] #`git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency "nokogiri", ">= 1.5.8"
  gem.add_dependency "activesupport", "~> 3.2.13"
  gem.add_dependency "htmlentities", ">= 4.3.1"

  gem.add_development_dependency "rspec", ">2"
end
