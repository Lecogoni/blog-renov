class Answer < ApplicationRecord
  belongs_to :answerable, polymorphic: true
  has_many :answers, as: :answerable
  
  belongs_to :user

  validates_presence_of :body
end
