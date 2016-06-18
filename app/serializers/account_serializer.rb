class AccountSerializer < ActiveModel::Serializer
  attributes :id, :login, :last_visit, :created_at
  belongs_to :profile, polymorphic: true do
    attrs = {}
    attrs[:type] = object.profile_type.downcase
    attrs.merge(object.profile.attributes.except('id', 'created_at', 'updated_at'))
  end
end

