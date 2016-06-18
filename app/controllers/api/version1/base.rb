module API
  module Version1
    class Base < Grape::API
      include API::Version1::Defaults
      mount API::Version1::User
      mount API::Version1::Accounts
      # mount API::Version1::Comments
      mount API::Version1::Tickets
      add_swagger_documentation info: {
          title: "API сервиса TicketManager, v1.0"
      }

      def self.codes(additional=[])
        [
            { code: 401, message: "Unauthorized access to method (invalid/expired token)" },
            { code: 403, message: "User does not have access to this method or resource" }
        ].append(additional)
      end
    end
  end
end