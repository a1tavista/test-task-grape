module API
  module Version1
    class Tickets < Grape::API
      resource :tickets, desc: "Операции над задачами" do
        desc 'Возвращает все задачи, доступные для просмотра пользователю.' do
          detail 'В ответе будут содержаться все задачи, к которым пользователь с текущим access_token имеет доступ. '\
                 'Например, для клиента будут видны только те задачи, к которым он привязан, в то время как '\
                 'администратор получит все зарегистрированные задачи.'
        end
        get do
          authenticate!
          if current_user.customer?
            Ticket.find_by_customer_id(current_user.profile.id)
          elsif current_user.admin?
            Ticket.all
          end
        end


        params do
          requires :id, type: Integer, desc: 'ID задачи'
        end
        route_param :id do
          desc 'Возвращает информацию о задаче с указанным ID'
          get serializer: SingleTicketSerializer do
            authenticate!
            Ticket.find(params[:id])
          end

          desc 'Возвращает комментарии к задаче с указанным ID'
          get :comments do
            authenticate!
            Ticket.find(params[:id]).comments
          end

          desc 'Создает новый комментарий к задаче с указанным ID'
          params do
            requires :text, type: String, desc: 'Текст комментария'
          end
          post :comments do
            authenticate!
            comment = Comment.new
            comment.account_id = current_user.id
            comment.ticket = Ticket.find(params[:id])
            comment.text = params[:text]
            comment.save
          end
        end

        desc 'Создает новую задачу.'
        params do
          requires :title, type: String, desc: 'Заголовок задачи'
          requires :description, type: String, desc: 'Описание задачи'
          optional :customer_id, type: Integer, desc: 'ID клиента'
          optional :admin_id, type: Integer, desc: 'ID администратора'
          optional :relationship_id, type: Integer, desc: 'ID связанной задачи'
          optional :status, type: String, desc: 'Статус задачи (fresh/viewed/paid/completed/closed)'
        end
        post do
          authenticate!
          ticket = Ticket.new
          ticket.title = params[:title]
          ticket.description = params[:description]
          ticket.customer = current_user.customer? ? current_user.profile : Account.find_by_id(params[:customer_id]).profile
          ticket.admin = current_user.admin? ? current_user.profile : Account.find_by_id(params[:admin_id]).profile
          ticket.status = params[:status]
          ticket.relationship = Ticket.find(params[:relationship_id])
          ticket.save!
        end

        desc 'Обновляет задачу с заданным ID'
        params do
          requires :id, type: Integer, desc: 'ID задачи'
          optional :title, type: String, desc: 'Заголовок задачи'
          optional :description, type: String, desc: 'Описание задачи'
          optional :customer_id, type: Integer, desc: 'ID клиента'
          optional :admin_id, type: Integer, desc: 'ID администратора'
          optional :relationship_id, type: Integer, desc: 'ID связанной задачи'
          optional :status, type: String, desc: 'Статус задачи (fresh/viewed/paid/completed/closed)'
        end
        route_param :id do
          put do
            authenticate!
            ticket = Ticket.find(params[:id])
            ticket.update(declared_params)
          end
        end

        desc 'Удаляет задачу с заданным ID'
        params do
          requires :id, type: Integer, desc: 'ID задачи'
        end
        route_param :id do
          delete do
            authenticate!
            ticket = Ticket.find(params[:id])
            related = Ticket.where(relationship_id: params[:id])
            related.each { |t| t.relationship_id = nil; t.save }
            ticket.destroy
            ticket.destroyed?
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