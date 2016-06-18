class CommentSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at
  attribute :account, key: :author do
    {
        id: object.account.id,
        firstname: object.account.profile.firstname,
        secondname: object.account.profile.secondname,
        lastname: object.account.profile.lastname
    }
  end
end
