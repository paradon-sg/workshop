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
    assert_equal "User was successfully created.", flash[:notice]
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
    assert_response :see_other
    assert_equal "User was successfully updated.", flash[:notice]
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
    assert_response :see_other
    assert_equal "User was successfully destroyed.", flash[:notice]
    assert_not User.exists?(@user.id)
    assert User.exists?(users(:two).id)
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

  test "json urls are not routed" do
    get "/users.json"
    assert_response :not_found

    get "/users/#{@user.id}.json"
    assert_response :not_found
  end

  test "create ignores client supplied identity and timestamps" do
    post users_url, params: { user: { email: "protected@example.com", id: @user.id,
      created_at: "2000-01-01T00:00:00Z", updated_at: "2000-01-01T00:00:00Z" } }

    created = User.last
    assert_redirected_to user_url(created)
    assert_not_equal @user.id, created.id
    assert_not_equal Time.utc(2000), created.created_at
    assert_not_equal Time.utc(2000), created.updated_at
    assert_equal "protected@example.com", created.email
    assert_equal "jane@example.com", @user.reload.email
  end

  test "update ignores client supplied identity and timestamps" do
    original_created_at = @user.created_at
    other_attributes = users(:two).attributes

    patch user_url(@user), params: { user: { id: users(:two).id, email: "changed@example.com",
      created_at: "2000-01-01T00:00:00Z", updated_at: "2000-01-01T00:00:00Z" } }

    assert_redirected_to user_url(@user)
    assert_equal "changed@example.com", @user.reload.email
    assert_equal original_created_at, @user.created_at
    assert_not_equal Time.utc(2000), @user.updated_at
    assert_equal other_attributes, users(:two).reload.attributes
  end

  test "put updates all permitted attributes" do
    attributes = { email: "put@example.com", first_name: "Put", last_name: "Updated", phone: "+1 012-345-6789" }

    put user_url(@user), params: { user: attributes }

    assert_redirected_to user_url(@user)
    assert_equal attributes.stringify_keys, @user.reload.attributes.slice(*attributes.keys.map(&:to_s))
  end

  test "update clears optional fields without changing omitted fields" do
    patch user_url(@user), params: { user: { phone: "", last_name: "" } }

    assert_redirected_to user_url(@user)
    assert_equal "", @user.reload.phone
    assert_equal "", @user.last_name
    assert_equal "Jane", @user.first_name
    assert_equal "jane@example.com", @user.email
  end

  { missing: {}, empty: { user: {} }, scalar: { user: "invalid" },
    array: { user: [ { email: "invalid@example.com" } ] } }.each do |shape, parameters|
    test "create rejects #{shape} user parameters without writing records" do
      assert_no_difference("User.count") do
        post users_url, params: parameters
      end

      assert_response :bad_request
    end

    test "update rejects #{shape} user parameters without changing the record" do
      original_attributes = @user.attributes

      patch user_url(@user), params: parameters

      assert_response :bad_request
      assert_equal original_attributes, @user.reload.attributes
    end
  end

  { show: :get, update: :patch, destroy: :delete }.each do |action, method|
    test "#{action} returns not found for a missing user" do
      assert_no_difference("User.count") do
        public_send(method, user_url(id: 0), params: { user: { first_name: "Missing" } })
      end

      assert_response :not_found
    end
  end

  test "edit returns not found for a missing user" do
    get edit_user_url(id: 0)

    assert_response :not_found
  end

  test "new and edit forms expose the permitted user fields" do
    get new_user_url

    assert_response :ok
    assert_select "form[action=?][method=post]", users_path do
      %w[email first_name last_name phone].each do |attribute|
        assert_select "input[name=?]", "user[#{attribute}]"
      end
    end

    get edit_user_url(@user)

    assert_response :ok
    assert_select "form[action=?][method=post]", user_path(@user) do
      assert_select "input[name=_method][value=patch]"
      %w[email first_name last_name phone].each do |attribute|
        assert_select "input[name=?][value=?]", "user[#{attribute}]", @user.public_send(attribute)
      end
    end
  end

  test "user pages escape user supplied html" do
    @user.update!(first_name: "<script>alert('user')</script>")

    [ users_url, user_url(@user) ].each do |url|
      get url

      assert_response :ok
      assert_select "#user_#{@user.id}" do
        assert_select "script", count: 0
        assert_select "div", text: /#{Regexp.escape(@user.first_name)}/
      end
    end
  end

  test "failed html create displays errors and retains submitted values" do
    with_rejected_user do
      assert_no_difference("User.count") do
        post users_url, params: { user: { email: "invalid", first_name: "Retained" } }
      end
    end

    assert_response :unprocessable_content
    assert_select "h1", "New user"
    assert_select "li", "Email is invalid"
    assert_select "input[name=?][value=?]", "user[email]", "invalid"
    assert_select "input[name=?][value=?]", "user[first_name]", "Retained"
  end

  test "failed html update displays errors without persisting changes" do
    original_attributes = @user.attributes

    with_rejected_user do
      patch user_url(@user), params: { user: { email: "invalid" } }
    end

    assert_response :unprocessable_content
    assert_select "h1", "Editing user"
    assert_select "li", "Email is invalid"
    assert_select "input[name=?][value=?]", "user[email]", "invalid"
    assert_equal original_attributes, @user.reload.attributes
  end

  private

  def with_rejected_user
    # User currently has no validations. Temporarily reject saves to exercise
    # the controller's failure responses without adding production constraints.
    validation = ->(user) { user.errors.add(:email, "is invalid") }
    User.set_callback(:validate, :before, validation)
    yield
  ensure
    User.skip_callback(:validate, :before, validation)
  end
end
