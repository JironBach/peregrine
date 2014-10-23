# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.zoho.com',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['ZOHO_USERNAME'],
  :password       => ENV['ZOHO_PASSWORD'],
  :domain         => 'peregrineapp.com',
  :enable_starttls_auto => true
}
