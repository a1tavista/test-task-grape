module API
  module Version1
    class Accounts < Grape::API
      resource :accounts, desc: 'Операции с аккаунтами пользователей' do
        desc 'Возвращает список всех аккаунтов.' do
          http_codes []
        end
        get do
          authenticate!
          Account.all
        end

        resource :customers do
          desc 'Возвращает список всех клиентов, зарегистрированных в сервисе.' do
            http_codes []
          end
          get do
            authenticate!
            Account.customers
          end

          desc 'Регистрирует нового клиента.' do
            http_codes []
          end
          params do
            requires :login, type: String, desc: 'Логин клиента'
            requires :password, type: String, desc: 'Пароль клиента'
            requires :customer, type: Hash do
              requires :lastname, type: String, desc: 'Фамилия клиента'
              requires :firstname, type: String, desc: 'Имя клиента'
              requires :secondname, type: String, desc: 'Отчество клиента'
              optional :company_name, type: String, desc: 'Название компании'
              optional :phone, type: String, desc: 'Контактный телефон'
              optional :site, type: String, desc: 'Сайт компании/клиента'
              optional :description, type: String, desc: 'Краткое описание'
            end
          end
          post do
            authenticate!
            error!('422 Unprocessable Entity', 422) if Account.where(login: params[:login]).first
            account = Account.new(login: params[:login], password: params[:password], is_tmp_password: true)
            account.profile = Customer.create!(params[:customer])
            account.save!
          end
        end

        resource :admins do
          desc 'Возвращает список всех администраторов, зарегистрированных в сервисе.' do
            http_codes []
          end
          get do
            authenticate!
            Account.admins
          end

          desc 'Регистрирует нового администратора.' do
            http_codes []
          end
          params do
            requires :login, type: String, desc: 'Логин администратора'
            requires :password, type: String, desc: 'Пароль администратора'
            requires :admin, type: Hash do
              requires :lastname, type: String, desc: 'Фамилия администратора'
              requires :firstname, type: String, desc: 'Имя администратора'
              requires :secondname, type: String, desc: 'Отчество администратора'
              optional :is_super, type: Boolean, desc: 'Является ли данный администратор суперадминистратором?'
            end
          end
          post do
            authenticate!
            error!('422 Unprocessable Entity', 422) if Account.where(login: params[:login]).first
            account = Account.new(login: params[:login], password: params[:password], is_tmp_password: true)
            account.profile = Admin.create!(params[:admin])
            account.save!
          end
        end

        desc 'Возвращает полную информацию об аккаунте с заданным ID.' do
          http_codes []
        end
        params do
          requires :id, type: Integer, desc: 'ID пользователя'
        end
        route_param :id do
          get do
            authenticate!
            Account.find(params[:id])
          end
        end

        desc 'Изменяет персональную информацию пользователя с заданным ID.' do
          http_codes []
        end
        params do
          requires :id, type: Integer, desc: 'ID пользователя'
          optional :admin, type: Hash do
            optional :lastname, type: String, desc: 'Фамилия пользователя'
            optional :firstname, type: String, desc: 'Имя пользователя'
            optional :secondname, type: String, desc: 'Отчество пользователя'
          end
          optional :customer, type: Hash do
            optional :lastname, type: String, desc: 'Фамилия пользователя'
            optional :firstname, type: String, desc: 'Имя пользователя'
            optional :secondname, type: String, desc: 'Отчество пользователя'
            optional :company_name, type: String, desc: 'Название компании'
            optional :phone, type: String, desc: 'Контактный телефон'
            optional :site, type: String, desc: 'Сайт компании/клиента'
            optional :description, type: String, desc: 'Краткое описание'
          end
        end
        route_param :id do
          put do
            authenticate!
            acc = Account.find(params[:id])
            acc.profile.update! declared_params[acc.profile_type.downcase]
          end
        end

        desc 'Удаляет аккаунт с заданным ID.' do
          http_codes []
        end
        params do
          requires :id, type: Integer, desc: 'ID пользователя'
        end
        route_param :id do
          delete do
            authenticate!
            acc = Account.find(params[:id])
            error!('403 Forbidden', 403) if acc.admin? and acc.profile.is_super?
            acc.profile.destroy
            acc.destroy
          end
        end
      end

      helpers do
        def declared_params
          declared(params.except('access_token'), include_missing: false)
        end
      end
    end
  end
end