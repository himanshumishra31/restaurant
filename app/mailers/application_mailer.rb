class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.email_id
  layout 'mailer'
end
