class Part < ApplicationRecord
  belongs_to :article
  
  validates :element_type, inclusion: { in: ['paragraph', 'image', 'video-embeb']}
  
  has_rich_text :content
  has_one_attached :image

  def paragraph?
      element_type === 'paragraph'
  end

  def image?
      element_type === 'image'
  end
end
 