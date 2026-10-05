class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  # Lists all users as HTML or JSON, without pagination.
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  # Displays the user loaded by set_user as HTML or JSON.
  def show
  end

  # GET /users/new
  # Displays the creation form with an unsaved user.
  def new
    @user = User.new
  end

  # GET /users/1/edit
  # Displays the edit form for the user loaded by set_user.
  def edit
  end

  # POST /users or /users.json
  # Creates a user from user_params; redirects HTML to the user or returns
  # the user as JSON with status 201 and its location.
  # If saving returns false, renders the new form or JSON errors with status 422.
  # Parameter errors from user_params and database errors propagate.
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  # Updates the loaded user with user_params; redirects HTML to the user with
  # status 303 or returns the user as JSON with status 200 and its location.
  # If updating returns false, renders the edit form or JSON errors with status 422.
  # Parameter errors from user_params and database errors propagate.
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  # Deletes the loaded user; redirects HTML to the user list with status 303
  # or returns an empty JSON response with status 204.
  # Propagates ActiveRecord::RecordNotDestroyed if a destroy callback aborts,
  # as well as database errors.
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Loads @user from the required scalar id parameter before member actions.
    # Propagates ActionController::ParameterMissing for an invalid id parameter
    # or ActiveRecord::RecordNotFound when no user matches.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Returns permitted scalar email, first_name, last_name, and phone values
    # from the user parameter, discarding other fields.
    # Raises ActionController::ParameterMissing unless user is a hash that
    # remains nonempty after filtering; individual fields are optional.
    def user_params
      params.expect(user: [ :email, :first_name, :last_name, :phone ])
    end
end
