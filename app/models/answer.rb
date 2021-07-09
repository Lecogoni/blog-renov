class Answer < ApplicationRecord
  belongs_to :answerable, polymorphic: true
  has_many :answers, as: :answerable

  validates_presence_of :body
end
