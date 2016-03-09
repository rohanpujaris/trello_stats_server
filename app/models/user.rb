class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  belongs_to :member
  has_many :sync_records

  def create_sync_record(sync_type)
    sync_records.create(category: sync_type, synced_time: Time.now)
  end
end
