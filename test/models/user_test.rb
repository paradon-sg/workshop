require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "saves with all attributes" do
    user = User.new(email: "new@example.com", first_name: "New", last_name: "User", phone: "0800000000")

    assert user.save
    assert_equal({ "email" => "new@example.com", "first_name" => "New", "last_name" => "User", "phone" => "0800000000" },
      user.reload.attributes.slice("email", "first_name", "last_name", "phone"))
    assert_not_nil user.created_at
    assert_not_nil user.updated_at
  end

  test "loads fixture attributes" do
    user = users(:one)

    assert_equal "Jane", user.first_name
    assert_equal "Doe", user.last_name
    assert_equal "0812345678", user.phone
  end

  test "preserves unicode names and formatted phone numbers" do
    user = User.create!(email: "unicode@example.com", first_name: "สมชาย", last_name: "O’Connor", phone: "+66 (0)81-234-5678")

    user.reload
    assert_equal "สมชาย", user.first_name
    assert_equal "O’Connor", user.last_name
    assert_equal "+66 (0)81-234-5678", user.phone
  end

  test "allows omitted optional attributes" do
    user = User.create!

    assert_equal [ nil, nil, nil, nil ], user.reload.attributes.values_at("email", "first_name", "last_name", "phone")
  end

  test "allows duplicate emails under the current schema" do
    duplicate = User.create!(email: users(:one).email)

    assert_equal users(:one).email, duplicate.reload.email
    assert_not_equal users(:one).id, duplicate.id
  end

  test "can clear optional attributes without changing the other fields" do
    user = users(:one)
    original_email = user.email

    user.update!(first_name: "", last_name: nil, phone: "")

    assert_equal [ original_email, "", nil, "" ], user.reload.attributes.values_at("email", "first_name", "last_name", "phone")
  end
end
