require 'trello'

Trello.configure do |config|
  config.developer_public_key = TRELLO_PUBLIC_KEY
  config.member_token = ''
end

