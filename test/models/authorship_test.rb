require "test_helper"

class AuthorshipTest < ActiveSupport::TestCase
  test "links an author to a book only once" do
    authorship = Authorship.new(author: authors(:terry), book: books(:mort))

    assert_not authorship.valid?
    assert_includes authorship.errors[:book_id], "has already been taken"
  end
end
