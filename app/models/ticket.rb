class Ticket < ActiveRecord::Base
  has_many :comments
  has_many :relations, class_name: 'Ticket',
           foreign_key: 'relationship_id'
  belongs_to :customer
  belongs_to :admin
  belongs_to :relationship, class_name: 'Ticket'

  # enum status: [:fresh, :viewed, :paid, :completed, :closed]
  # enum status: { fresh: :fresh, viewed: :viewed, paid: :paid, completed: :completed, closed: :closed }

  validates :title, :description, :customer_id, presence: true
  validates :title, length: { maximum: 250 }
end
