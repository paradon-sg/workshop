require "test_helper"

class BookTest < ActiveSupport::TestCase
  test "belongs to a category" do
    assert_equal categories(:fiction), books(:mort).category
  end

  test "has many authors" do
    assert_equal [ authors(:neil), authors(:terry) ].sort, books(:good_omens).authors.sort
  end

  test "saves with authors" do
    book = Book.create!(title: "New Book", category: categories(:science), authors: [ authors(:neil) ])

    assert_equal [ authors(:neil) ], book.reload.authors
  end

  test "requires a title" do
    book = Book.new(title: "", category: categories(:fiction))

    assert_not book.valid?
    assert_includes book.errors[:title], "can't be blank"
  end

  test "requires a category" do
    book = Book.new(title: "No Category")

    assert_not book.valid?
    assert_includes book.errors[:category], "must exist"
  end

  test "destroying a book removes its authorships but keeps the authors" do
    assert_difference -> { Authorship.count }, -2 do
      books(:good_omens).destroy
    end
    assert Author.exists?(authors(:neil).id)
  end

  test "search_by_title matches part of the title, ignoring case" do
    assert_equal [ books(:good_omens) ], Book.search_by_title("omen").to_a
  end

  test "search_by_title returns all books when the query is blank" do
    assert_equal Book.count, Book.search_by_title(" ").count
  end

  test "search_by_title treats LIKE wildcards literally" do
    assert_empty Book.search_by_title("%")
  end
end
