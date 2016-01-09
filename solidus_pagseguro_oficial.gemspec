# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_pagseguro_oficial'
  s.version     = '1.1.2'
  s.summary     = 'Solidus Extension to PagSeguro integration'
  s.description = s.summary
  s.required_ruby_version = '>= 2.2.2'

  s.author    = 'Diego Domingues'
  s.email     = 'diego.domingues16@gmail.com'
  s.homepage  = 'https://github.com/ddomingues/solidus_pagseguro_oficial'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_runtime_dependency 'solidus_core', '~> 1.1'
  s.add_runtime_dependency 'solidus_br_common', '~> 1.1'
  s.add_dependency 'pagseguro-oficial', '~> 2.4'

  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails', '~> 4.1', '>= 4.1.0'
  s.add_development_dependency 'database_cleaner', '~> 1.5', '>= 1.5.1'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.4'
  s.add_development_dependency 'sass-rails', '~> 5.0.4'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
