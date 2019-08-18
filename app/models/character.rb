class Character < ApplicationRecord
  belongs_to :work

  enum gender: {
    unknown: 0,
    male: 1,
    female: 2,
  }

  validates :name, presence: true, length: { maximum: 255 }
  validates :name_kana, length: { maximum: 255, allow_blank: true }
  validates :birth_month, inclusion: { in: (1..12) }
  validates :birth_day, inclusion: { in: (1..31) }
end
