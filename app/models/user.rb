# Merge this model with member model. Keeping it seprate seems bad decision

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable

  include DeviseTokenAuth::Concerns::User

  belongs_to :member
  has_many :sync_records
  has_many :leaves, through: :member
  has_many :leaves_updated_by_member, through: :member

  delegate :role, :role_cd, :admin?, :team_lead?, :admin_or_team_lead?,
     to: :member, allow_nil: true

  def sync_record(sync_type)
    sync_record = sync_records.create(sync_type: sync_type, sync_start_time: Time.now)
    yield
    sync_record.update_column(:sync_end_time, Time.now)
  end

  def build_auth_header(token, client_id='default')
    client_id ||= 'default'
    expiry = self.tokens[client_id]['expiry'] || self.tokens[client_id][:expiry]
    {
      'access-token' => token,
      'token-type'   => 'Bearer',
      'client'       => client_id,
      'expiry'       => expiry.to_s,
      'uid'          => self.uid,
      'user-role'    => self.role.to_s,
      'member-id'    => self.member_id
    }
  end
end
