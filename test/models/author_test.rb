require "test_helper"

class AuthorTest < ActiveSupport::TestCase
  test "has many books" do
    assert_equal [ books(:good_omens), books(:mort) ].sort, authors(:terry).books.sort
  end

  test "requires a name" do
    author = Author.new(name: "")

    assert_not author.valid?
    assert_includes author.errors[:name], "can't be blank"
  end

  test "destroying an author removes its authorships but keeps the books" do
    author = authors(:terry)

    assert_difference -> { Authorship.count }, -2 do
      author.destroy
    end
    assert Book.exists?(books(:mort).id)
  end
end
