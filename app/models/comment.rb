class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user
  #validates :body, presence :true

  def comment_time
    time = Time.now
    date = self.created_at
    if time.year == date.year
      I18n.localize Date.today, format: :short
    else
      self.created_at
    end
  end

end


