class TestController < ApplicationController
    before_action :authenticate
    def profile
        render json: current_account, status: :ok
    end
end