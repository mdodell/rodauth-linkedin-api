class ApplicationController < ActionController::API
    private

    def authenticate
      rodauth.require_authentication # redirect to login page if not authenticated
    end
end
