module API
  module Version1
    class User < Grape::API
      resource :user, desc: 'Авторизация и действия над текущим пользователем' do
        desc 'Возвращает access_token для пользователя с указанными логином и паролем.'
        params do
          requires :login, type: String, desc: 'Логин пользователя'
          requires :password, type: String, desc: 'Пароль пользователя'
        end
        get :authorize do
          account = Account.find_by(login: params[:login]).try(:authenticate, params[:password])
          error_response('403 Forbidden', 403) unless account
          payload = { id: account.id, exp: Time.now.to_i + Rails.configuration.x.jwt_token_expiration_time }
          token = JWT.encode(payload, Rails.configuration.x.jwt_salt, 'HS256')
          { access_token: token, role: account.profile_type.downcase }
        end

        desc 'Возвращает профиль текущего пользователя.'
        get :profile do
          authenticate!
          current_user
        end
      end
    end
  end
end