require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "has many books" do
    assert_equal [ books(:good_omens), books(:mort) ].sort, categories(:fiction).books.sort
  end

  test "requires a name" do
    category = Category.new(name: "")

    assert_not category.valid?
    assert_includes category.errors[:name], "can't be blank"
  end

  test "requires a unique name" do
    category = Category.new(name: categories(:fiction).name)

    assert_not category.valid?
    assert_includes category.errors[:name], "has already been taken"
  end

  test "cannot be destroyed while it has books" do
    category = categories(:fiction)

    assert_not category.destroy
    assert Category.exists?(category.id)
  end

  test "can be destroyed without books" do
    assert categories(:science).destroy
  end
end
