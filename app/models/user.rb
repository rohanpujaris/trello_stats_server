class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  belongs_to :member
  has_many :sync_records

  def sync_record(sync_type)
    sync_record = sync_records.create(sync_type: sync_type, sync_start_time: Time.now)
    yield
    sync_record.update_column(:sync_end_time, Time.now)
  end
end
