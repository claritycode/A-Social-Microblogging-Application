# == Schema Information
#
# Table name: favorites
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  micropost_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Favorite < ActiveRecord::Base
  attr_accessible :micropost_id
  belongs_to :user
  belongs_to :micropost

  
  validates :user_id, presence: true
  validates :micropost_id, presence: true
end
