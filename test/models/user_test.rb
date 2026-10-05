require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "saves with all attributes" do
    user = User.new(email: "new@example.com", first_name: "New", last_name: "User", phone: "0800000000")

    assert user.save
    assert_equal "new@example.com", user.reload.email
  end

  test "loads fixture attributes" do
    user = users(:one)

    assert_equal "Jane", user.first_name
    assert_equal "Doe", user.last_name
    assert_equal "0812345678", user.phone
  end
end
