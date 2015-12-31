%w(development production staging).each do |environment|
  Spree::Gateway::Pagseguro.create!(
      {
        name: "PagSeguro - #{environment}",
        description: "PagSeguro gateway para #{environment}.",
        environment: environment,
        active: true
      }
  )
end