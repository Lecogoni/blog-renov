class UserMailer < ApplicationMailer

  default from: 'no-reply@monsite.fr'

  # email when a guest apply to be a member
  def registration_email(guest)
    #on récupère l'instance guest pour ensuite pouvoir la passer à la view en @user
    @guest = guest

    #on définit une variable @url qu'on utilisera dans la view d’e-mail
    @url  = 'http://monsite.fr/login' 

    # c'est cet appel à mail() qui permet d'envoyer l’e-mail en définissant destinataire et sujet.
    mail(to: @guest.email, subject: 'Bienvenue chez nous !') 
  end


  # email to website manager to alert of new member request
  def new_registration_member(guest)
    @guest = guest
    @url  = 'http://monsite.fr/login' 
    mail(to: "francine@yopmail.com", subject: 'Nouvelle demande de membre') 
  end

  # email to confirm guest their application
  def confirm_registration_member(user, raw)
    @user = user
    @url  = 'http://monsite.fr/login'
    @raw = raw
    @link  = edit_user_password_url(reset_password_token: @raw)
    mail(to: user.email, subject: "Confirmation d'insciption à paye ton site!") 
  end

  # email to alert guest that its membership request had been refused
  def refuse_guest_registration(guest)
    @guest = guest
    @url  = 'http://monsite.fr/login' 
    mail(to: "francine@yopmail.com", subject: "Votre demande sur le ...... a été refusée") 
  end
  
  # email when a user is created by an admin user
  def invited_user_by_admin_email(user, raw)
    @user = user
    @url  = 'http://monsite.fr/login'
    @raw = raw
    @link  = edit_user_password_url(reset_password_token: @raw)
    mail(to: "francine@yopmail.com", subject: "Invitation au site paye ton site") 
  end


  # email when an admin delete a user article or post_url
  def admin_delete_article_email(article)
    @article = article
    @user = @article.user
    mail(to: @user.email, subject: "Renov Blog : suppression de l'une de vos publications")
  end

end

