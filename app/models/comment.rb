class Comment < ActiveRecord::Base
  belongs_to :account
  belongs_to :ticket

  validates :text, length: { maximum: 140 }, presence: true
  validates :account_id, :ticket_id, presence: true
end
