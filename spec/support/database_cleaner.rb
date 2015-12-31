RSpec.configure do |config|
  # Capybara javascript drivers require transactional fixtures set to false, and we use DatabaseCleaner
  # to cleanup after each test instead.  Without transactional fixtures set to false the records created
  # to setup a test will be unavailable to the browser, which runs under a separate server instance.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  # Before each spec check if it is a Javascript test and switch between using database transactions or not where necessary.
  config.before(:each) do
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
