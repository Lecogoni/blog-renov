module PagesHelper

  def is_member_request?
    Guest.all.count != 0
  end

end
