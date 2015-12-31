FactoryGirl.define do
  factory :pagseguro_payment_method, class: Spree::Gateway::Pagseguro do
    name 'PagSeguro'
  end

  factory :country_brazil, class: Spree::Country do
    iso_name 'BRASIL'
    name 'Brasil'
    iso 'BR'
    iso3 'BR'
    numcode 55
  end

  factory :state_sao_paulo, class: Spree::State do
    name 'São Paulo'
    abbr 'SP'
    country {|country| country.association(:country_brazil) }
  end

  factory :address_brazil, class: Spree::Address do
    firstname 'José'
    lastname 'Maria'
    company 'Company'
    address1 'Avenida Paulista'
    city {|address| address.association(:city)}
    zipcode '01310917'
    phone '11-989898989'
    alternative_phone '11-987878787'
    number 2323
    district 'Bela Vista'

    state { |address| address.association(:state_sao_paulo) }
    country do |address|
      if address.state
        address.state.country
      else
        address.association(:country_brazil)
      end
    end
  end
end

FactoryGirl.modify do
  factory :shipping_method do
    name 'SEDEX'
  end
end
