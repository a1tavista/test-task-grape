class CustomerSerializer < ActiveModel::Serializer
  has_one :account, as: :profile
  attributes :firstname, :secondname, :lastname, :phone, :site_url, :company_name
end


