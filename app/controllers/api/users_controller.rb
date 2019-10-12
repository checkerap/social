class Api::UsersController < ApplicationController
    before_action :set_user, only: [:follow, :unfollow, :followers]
    rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

    def create
        @user = User.new(user_params)

        if @user.save
            json_string = UserSerializer.new(@user).serialized_json
            render json: json_string, status: :ok
        else
            return head :unprocessable_entity
        end
    end

    def follow
        @followed_user = User.find params[:id]
        unless @followed_user.present? and !@user.followed_users.include?(@followed_user)
            return head :unprocessable_entity
        end

        @user.followed_users << @followed_user
        return head :ok
    end

    def unfollow
        @followed_user = User.find params[:id]
        unless @followed_user.present? and @user.followed_users.include?(@followed_user)
            return head :unprocessable_entity
        end

        @user.followed_users.delete @followed_user
        return head :ok
    end

    def followers
        @followers = @user.follower_users
        
        json_string = UserSerializer.new(@followers).serialized_json
        render json: json_string
    end

    private
        def set_user
            @user = User.find params[:user_id]
        end

        def user_params
            params.require(:user).permit(:name, :username)
        end

        def record_not_found 
            head :unprocessable_entity
        end
end
