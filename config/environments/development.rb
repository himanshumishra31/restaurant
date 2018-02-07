Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.after_initialize do
    Bullet.enable = true
    Bullet.rails_logger = true
  end
  config.consider_all_requests_local = true
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end
  config.action_mailer.default_url_options = { host: "localhost:3000" }
  config.action_mailer.delivery_method = :letter_opener
  # config.action_mailer.smtp_settings = {
  #   address: "smtp.gmail.com",
  #   port: 587,
  #   domain: "mail.gmail.com",
  #   authentication: :plain,
  #   user_name: Rails.application.secrets.email_id ,
  #   password: Rails.application.secrets.password ,
  #   enable_starttls_auto: true
  # }
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.quiet = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  Paperclip.options[:command_path] = "/usr/local/bin/"
  # config.middleware.insert_before Rack::Sendfile, DeltaLogger
end
