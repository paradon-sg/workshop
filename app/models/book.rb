class Book < ApplicationRecord
  belongs_to :category
  has_many :authorships, dependent: :destroy
  has_many :authors, through: :authorships

  validates :title, presence: true

  scope :search_by_title, ->(query) {
    next all if query.blank?

    where("title LIKE ?", "%#{sanitize_sql_like(query.strip)}%")
  }
end
