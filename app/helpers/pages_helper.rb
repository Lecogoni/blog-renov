module PagesHelper

  def is_member_request?
    Guest.all.count != 0
  end


  def number_of_members
    User.all.count
  end

  def number_of_articles
    Article.all.count
  end

  def number_of_posts
    Post.all.count
  end

end
