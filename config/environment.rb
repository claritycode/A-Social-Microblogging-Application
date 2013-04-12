# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SampleApp::Application.initialize!

# ActionMailer::Base.smtp_settings = {
#       :address              => "smtp.gmail.com",
#       :port                 => 587,
#       :domain               => "gmail.com",
#       :user_name            => "parthpatel.org" ,
#       :password             => "<>?Shrisai" ,
#       :authentication       => "plain",
#       :enable_starttls_auto => true
# }