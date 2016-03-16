Devise.setup do |config|
  config.mailer_sender = 'noreply@trellostatsserver.com'
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..72
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.secret_key = '05e6bfeb1df52a8af297f31a06f6042002a2caa12e2b8d2c52f5c055106d2ecdff4da5f121c5e8167aeea7037a11989a6f8c9f4a6544f3bab8c7dc8b093afa93'
end
