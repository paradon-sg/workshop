class HomeController < ApplicationController
  # GET /
  # Landing page linking to every section of the app.
  def index
    @sections = [
      { name: "Books", path: books_path, count: Book.count, description: "Titles with their category and authors." },
      { name: "Authors", path: authors_path, count: Author.count, description: "People who wrote the books." },
      { name: "Categories", path: categories_path, count: Category.count, description: "Groups that books belong to." },
      { name: "Users", path: users_path, count: User.count, description: "People registered in the app." }
    ]
  end
end
