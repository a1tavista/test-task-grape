module HavingAccount
  extend ActiveSupport::Concern

  included do
    has_one :account, as: :profile
    has_many :tickets
    validates :firstname, :secondname, :lastname, presence: true
  end
end