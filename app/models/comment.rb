class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user
  #validates :body, presence :true

  def comment_time
    time = Time.now
    if time.year == self.created_at.year
      self.created_at.strftime("%d %B") 
    else
      self.created_at.strftime("%d %B %Y")
    end
  end

end
