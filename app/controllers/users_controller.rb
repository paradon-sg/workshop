class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users
  # Lists all users without pagination.
  def index
    @users = User.all
  end

  # GET /users/1
  # Displays the user loaded by set_user.
  def show
  end

  # GET /users/new
  # Displays the creation form for a new, unsaved user.
  def new
    @user = User.new
  end

  # GET /users/1/edit
  # Displays the edit form for the user loaded by set_user.
  def edit
  end

  # POST /users
  # Creates a user from user_params and redirects to it. If saving returns
  # false, renders the new form with status 422. Parameter and database
  # exceptions propagate.
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /users/1
  # Updates the user loaded by set_user with user_params and redirects to it
  # with status 303. If updating returns false, renders the edit form with
  # status 422. Parameter and database exceptions propagate.
  def update
    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /users/1
  # Destroys the user loaded by set_user and redirects to the list with status
  # 303. Propagates ActiveRecord::RecordNotDestroyed if a callback aborts
  # destruction, as well as database exceptions.
  def destroy
    @user.destroy!

    redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other
  end

  private
    # Loads and returns @user using the required scalar id parameter.
    # Raises ActionController::ParameterMissing for a missing id, blank string,
    # or non-scalar id, or ActiveRecord::RecordNotFound when no user matches.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Returns permitted email, first_name, last_name, and phone scalar values
    # from the user parameter, discarding other fields. Individual fields are
    # optional. Raises ActionController::ParameterMissing if user is not a hash
    # or is missing or empty after filtering.
    def user_params
      params.expect(user: [ :email, :first_name, :last_name, :phone ])
    end
end
