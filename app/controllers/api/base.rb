module API
  class Base < Grape::API
    mount API::Version1::Base
  end
end