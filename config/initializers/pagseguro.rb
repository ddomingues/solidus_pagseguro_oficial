I18n.locale = 'pt-BR'

PagSeguro.configure do |config|
  config.email = ENV.fetch('PAGSEGURO_EMAIL')
  config.token = ENV.fetch('PAGSEGURO_TOKEN')
  config.environment = Rails.env.production? ? :production : :sandbox
end

