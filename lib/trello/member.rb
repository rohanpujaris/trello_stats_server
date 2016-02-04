# This was a trial to override gem to get gravatar but gravatar of other user is not returned
# It returns gravatar of users whose acess token we are using

module Trello
  class Member < BasicData
    register_attributes :id, :username, :email, :full_name, :initials,
      :avatar_id, :gravatar_hash, :bio, :url,
      readonly: [ :id, :username, :avatar_id, :url ]

    def update_fields(fields)
      attributes[:id]        = fields['id']
      attributes[:full_name] = fields['fullName']
      attributes[:email]     = fields['email']
      attributes[:username]  = fields['username']
      attributes[:initials]  = fields['initials']
      attributes[:avatar_id] = fields['avatarHash']
      attributes[:gravatar_hash] = fields['gravatarHash']
      attributes[:bio]       = fields['bio']
      attributes[:url]       = fields['url']
      self
    end
  end
end