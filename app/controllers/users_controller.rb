class UsersController < ApplicationController
    before_action :authenticate_user!
    def index
        if current_user
          redirect_to home_path
        end
    end
end
