require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "root links to every section" do
    get root_url

    assert_response :success
    [ books_path, authors_path, categories_path, users_path ].each do |path|
      assert_select "main a[href=?]", path
    end
  end

  test "root shows record counts" do
    get root_url

    assert_select "a[href=?]", books_path, text: /#{Book.count} records/
  end
end
