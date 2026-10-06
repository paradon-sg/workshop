class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  # Lists all users as HTML or JSON without pagination.
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  # Displays the user loaded by set_user as HTML or JSON.
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

  # POST /users or /users.json
  # Creates a user from user_params; redirects HTML to the user or returns JSON
  # with status 201. If saving returns false, renders the new form or JSON errors
  # with status 422. Parameter and database exceptions propagate.
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
  # Updates the user loaded by set_user with user_params; redirects HTML to the
  # user with status 303 or returns JSON with status 200. If updating returns
  # false, renders the edit form or JSON errors with status 422. Parameter and
  # database exceptions propagate.
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
  # Destroys the user loaded by set_user; redirects HTML to the list with status
  # 303 or returns an empty JSON response with status 204. Propagates
  # ActiveRecord::RecordNotDestroyed if a callback aborts destruction, as well
  # as database exceptions.
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
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
