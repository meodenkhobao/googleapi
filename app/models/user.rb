class User < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :mail, presence: true, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  class << self
    def find_with_omniauth omniauth
      info = omniauth['info']
      if user = User.find_by(mail: info['email'])
        user.update_attributes name: info['name'], photo: info['image'],
          google_id: omniauth['uid'],
          access_token: omniauth['credentials']['token'],
          google_profile_url: info['urls'].values.first
      else
        user = User.create name: info['name'], photo: info['image'],
          mail: info['email'], google_id: omniauth['uid'],
          access_token: omniauth['credentials']['token'],
          google_profile_url: info['urls'].values.first
      end
      user
    end
  end

  def google_client
    @google_client ||= Google::APIClient.new
    @google_client.authorization.access_token = access_token
    @google_client
  end
end
