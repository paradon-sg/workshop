require "test_helper"

class AuthorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @author = authors(:terry)
  end

  test "should get index" do
    get authors_url

    assert_response :success
    assert_select "#author_#{@author.id}", text: /Terry Pratchett/
  end

  test "should get new" do
    get new_author_url
    assert_response :success
  end

  test "should create author" do
    assert_difference("Author.count") do
      post authors_url, params: { author: { name: "Ursula K. Le Guin" } }
    end

    assert_redirected_to author_url(Author.last)
  end

  test "should not create author without a name" do
    assert_no_difference("Author.count") do
      post authors_url, params: { author: { name: "" } }
    end

    assert_response :unprocessable_content
    assert_select "li", "Name can't be blank"
  end

  test "should show author with their books" do
    get author_url(@author)

    assert_response :success
    assert_select "a[href=?]", book_path(books(:good_omens)), text: "Good Omens"
    assert_select "a[href=?]", book_path(books(:mort)), text: "Mort"
  end

  test "should get edit" do
    get edit_author_url(@author)
    assert_response :success
  end

  test "should update author" do
    patch author_url(@author), params: { author: { name: "Sir Terry Pratchett" } }

    assert_redirected_to author_url(@author)
    assert_equal "Sir Terry Pratchett", @author.reload.name
  end

  test "should destroy author and keep their books" do
    assert_difference("Author.count", -1) do
      delete author_url(@author)
    end

    assert_redirected_to authors_url
    assert Book.exists?(books(:mort).id)
  end
end
