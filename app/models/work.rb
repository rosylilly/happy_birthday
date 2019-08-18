class Work < ApplicationRecord
  has_many :characters, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: true }
end
