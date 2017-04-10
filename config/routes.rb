Rails.application.routes.draw do
  get 'expressly/api/registered'
  get 'expressly/api/user/:email' => 'expressly/api#customer_export', :constraints => { :email => /[^\/]+/ }
  post 'expressly/api/batch/invoice' => 'expressly/api#invoices'
  post 'expressly/api/batch/customer' => 'expressly/api#check_emails'  
  get 'expressly/api/:campaign_customer_uuid/migrate' => 'expressly/api#migrate'
end