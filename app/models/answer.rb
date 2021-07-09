class Answer < ApplicationRecord
  belongs_to :answerable, polymorphic: true

  validates_presence_of :body
end
