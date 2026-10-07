class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :set_form_options, only: %i[ new edit create update ]

  # GET /books
  def index
    @query = params[:query]
    @books = Book.search_by_title(@query).order(:title)
  end

  # GET /books/1
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  def create
    @book = Book.new(book_params)

    if @book.save
      redirect_to @book, notice: "Book was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Book was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy!

    redirect_to books_path, notice: "Book was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params.expect(:id))
    end

    # Choices for the category select and author checkboxes in the form.
    def set_form_options
      @categories = Category.order(:name)
      @authors = Author.order(:name)
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.expect(book: [ :title, :description, :category_id, author_ids: [] ])
    end
end
