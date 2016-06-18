class SingleTicketSerializer < ActiveModel::Serializer
  has_many :comments
  belongs_to :customer
  belongs_to :admin
  attributes :id, :title, :description, :status
  class CustomerSerializer < ActiveModel::Serializer
    attribute :id do
      object.account.id
    end
    attributes :firstname, :secondname, :lastname, :company_name, :phone, :site_url
  end
  class AdminSerializer < ActiveModel::Serializer
    attribute :id do
      object.account.id
    end
    attributes :firstname, :secondname, :lastname
  end
end
