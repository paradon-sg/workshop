require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { email: @user.email, first_name: @user.first_name, last_name: @user.last_name, phone: @user.phone } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { email: @user.email, first_name: @user.first_name, last_name: @user.last_name, phone: @user.phone } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end

  test "should save submitted attributes on create" do
    post users_url, params: { user: { email: "new@example.com", first_name: "New", last_name: "User", phone: "0800000000" } }

    user = User.last
    assert_equal "new@example.com", user.email
    assert_equal "New", user.first_name
    assert_equal "User", user.last_name
    assert_equal "0800000000", user.phone
  end

  test "should change attributes on update" do
    patch user_url(@user), params: { user: { first_name: "Updated" } }

    assert_equal "Updated", @user.reload.first_name
  end

  test "should ignore unpermitted attributes" do
    original_created_at = @user.created_at

    patch user_url(@user), params: { user: { first_name: "Updated", created_at: 1.year.ago } }

    assert_equal original_created_at, @user.reload.created_at
  end

  test "should return bad request when user params are missing" do
    assert_no_difference("User.count") do
      post users_url, params: { email: "new@example.com" }
    end

    assert_response :bad_request
  end

  test "should return not found for missing user" do
    get user_url(id: 0)
    assert_response :not_found
  end

  test "should list users as json" do
    get users_url(format: :json)

    assert_response :success
    emails = response.parsed_body.map { |user| user["email"] }
    assert_includes emails, users(:one).email
    assert_includes emails, users(:two).email
  end

  test "should show user as json" do
    get user_url(@user, format: :json)

    assert_response :success
    assert_equal @user.email, response.parsed_body["email"]
  end

  test "should create user as json" do
    assert_difference("User.count") do
      post users_url(format: :json), params: { user: { email: "api@example.com", first_name: "Api", last_name: "User", phone: "0811111111" } }
    end

    assert_response :created
    assert_equal "api@example.com", response.parsed_body["email"]
  end

  test "should update user as json" do
    patch user_url(@user, format: :json), params: { user: { last_name: "Changed" } }

    assert_response :ok
    assert_equal "Changed", response.parsed_body["last_name"]
  end

  test "should destroy user as json" do
    assert_difference("User.count", -1) do
      delete user_url(@user, format: :json)
    end

    assert_response :no_content
  end
end
