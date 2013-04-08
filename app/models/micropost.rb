# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  has_many :mentions, dependent: :destroy
  has_many :mentioned_users, through: :mentions, source: :user

  USERNAME_REGEX = /@\w+/i
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  default_scope order: 'microposts.created_at DESC'

  after_save :mention!

  def self.from_users_followed_by(user)
  	#followed_user_ids = user.followed_user_ids
  	#where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
  	followed_user_ids = "SELECT followed_id FROM relationships
  						WHERE follower_id = :user_id"
  	where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
  			user_id: user.id)
  end

  private 

    def mention!
      return unless mention?

      mentioned_people.each do |user|
        mentions.create!(user_id: user.id)
      end
    end

    def mention?
      content.match(USERNAME_REGEX)
    end

    def mentioned_people
      users = []
      content.clone.gsub!(USERNAME_REGEX).each do |username|
        user = User.find_by_username(username[1..-1])
        users << user if user
      end
      users.uniq
    end
end
