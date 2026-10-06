class Authorship < ApplicationRecord
  belongs_to :author
  belongs_to :book

  validates :book_id, uniqueness: { scope: :author_id }
end
