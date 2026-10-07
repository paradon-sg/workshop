require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:good_omens)
  end

  test "should get index" do
    get books_url

    assert_response :success
    assert_select "#book_#{@book.id}", text: /Good Omens.*Fiction.*Neil Gaiman, Terry Pratchett|Good Omens.*Fiction.*Terry Pratchett, Neil Gaiman/m
  end

  test "should filter index by title" do
    get books_url, params: { query: "mort" }

    assert_response :success
    assert_select "#book_#{books(:mort).id}"
    assert_select "#book_#{@book.id}", count: 0
  end

  test "should show a message when no books match the search" do
    get books_url, params: { query: "Nothing like this" }

    assert_response :success
    assert_select "p", text: "No books match \"Nothing like this\"."
  end

  test "should get new with category and author choices" do
    get new_book_url

    assert_response :success
    assert_select "select[name=?] option", "book[category_id]", text: "Science"
    assert_select "input[type=checkbox][name=?][value=?]", "book[author_ids][]", authors(:neil).id.to_s
  end

  test "should create book with authors" do
    assert_difference("Book.count") do
      post books_url, params: { book: { title: "Coraline", category_id: categories(:fiction).id, author_ids: [ authors(:neil).id ] } }
    end

    book = Book.last
    assert_redirected_to book_url(book)
    assert_equal [ authors(:neil) ], book.authors
  end

  test "should create book with a description" do
    post books_url, params: { book: { title: "Coraline", description: "A door to another world.", category_id: categories(:fiction).id } }

    assert_redirected_to book_url(Book.last)
    assert_equal "A door to another world.", Book.last.description
  end

  test "should not create book without a category" do
    assert_no_difference("Book.count") do
      post books_url, params: { book: { title: "Orphan", category_id: "" } }
    end

    assert_response :unprocessable_content
    assert_select "li", "Category must exist"
  end

  test "should show book with category and authors" do
    get book_url(@book)

    assert_response :success
    assert_select "a[href=?]", category_path(categories(:fiction)), text: "Fiction"
    assert_select "a[href=?]", author_path(authors(:neil)), text: "Neil Gaiman"
  end

  test "should show description as paragraphs" do
    get book_url(@book)

    assert_select "dd p", "The world is ending on Saturday."
    assert_select "dd p", "An angel and a demon would rather it didn't."
  end

  test "should show placeholder when description is blank" do
    get book_url(books(:mort))

    assert_select "dd", "No description"
  end

  test "should escape html in description" do
    @book.update!(description: "<script>alert('book')</script>")

    get book_url(@book)

    assert_select "#book_#{@book.id} script", count: 0
    assert_includes response.body, "&lt;script&gt;"
  end

  test "should get edit" do
    get edit_book_url(@book)

    assert_response :success
    assert_select "textarea[name=?]", "book[description]", text: /The world is ending on Saturday/
    assert_select "input[type=checkbox][value=?][checked]", authors(:terry).id.to_s
  end

  test "should update book authors and category" do
    patch book_url(@book), params: { book: { category_id: categories(:science).id, author_ids: [ authors(:terry).id ] } }

    assert_redirected_to book_url(@book)
    @book.reload
    assert_equal categories(:science), @book.category
    assert_equal [ authors(:terry) ], @book.authors
  end

  test "should remove all authors when none are checked" do
    patch book_url(@book), params: { book: { author_ids: [ "" ] } }

    assert_redirected_to book_url(@book)
    assert_empty @book.reload.authors
  end

  test "should not change authors when the update is invalid" do
    patch book_url(@book), params: { book: { title: "", author_ids: [ authors(:terry).id ] } }

    assert_response :unprocessable_content
    assert_equal [ authors(:neil), authors(:terry) ].sort, @book.reload.authors.sort
  end

  test "should destroy book" do
    assert_difference("Book.count", -1) do
      delete book_url(@book)
    end

    assert_redirected_to books_url
  end
end
