require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:fiction)
  end

  test "should get index" do
    get categories_url

    assert_response :success
    assert_select "#category_#{@category.id}", text: /Fiction/
  end

  test "should get new" do
    get new_category_url
    assert_response :success
  end

  test "should create category" do
    assert_difference("Category.count") do
      post categories_url, params: { category: { name: "History" } }
    end

    assert_redirected_to category_url(Category.last)
  end

  test "should not create category with a duplicate name" do
    assert_no_difference("Category.count") do
      post categories_url, params: { category: { name: @category.name } }
    end

    assert_response :unprocessable_content
    assert_select "li", "Name has already been taken"
  end

  test "should show category with its books" do
    get category_url(@category)

    assert_response :success
    assert_select "a[href=?]", book_path(books(:mort)), text: "Mort"
  end

  test "should get edit" do
    get edit_category_url(@category)
    assert_response :success
  end

  test "should update category" do
    patch category_url(@category), params: { category: { name: "Novels" } }

    assert_redirected_to category_url(@category)
    assert_equal "Novels", @category.reload.name
  end

  test "should destroy category without books" do
    assert_difference("Category.count", -1) do
      delete category_url(categories(:science))
    end

    assert_redirected_to categories_url
  end

  test "should not destroy category that has books" do
    assert_no_difference("Category.count") do
      delete category_url(@category)
    end

    assert_redirected_to category_url(@category)
    follow_redirect!
    assert_select "#alert", /dependent books exist/
  end
end
