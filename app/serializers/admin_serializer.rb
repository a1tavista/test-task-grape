class AdminSerializer < ActiveModel::Serializer
  has_one :account, as: :profile
  attributes :firstname, :secondname, :lastname, :is_super, :updated_at

  def profile
    attributes :firstname
  end
end

