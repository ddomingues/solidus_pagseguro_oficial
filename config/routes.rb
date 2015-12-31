Spree::Core::Engine.routes.draw do
  post '/pagseguro', to: 'pagseguro#init_transaction', as: :pagseguro_init_transaction
  post '/pagseguro/notify', to: 'pagseguro#notify', as: :pagseguro_notify
  get '/pagseguro/confirm', to: 'pagseguro#confirm', as: :pagseguro_confirm
end
