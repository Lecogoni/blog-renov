class UserMailer < ApplicationMailer

  default from: 'no-reply@monsite.fr'

  def registration_email(guest)
    #on récupère l'instance guest pour ensuite pouvoir la passer à la view en @user
    @guest = guest

    #on définit une variable @url qu'on utilisera dans la view d’e-mail
    @url  = 'http://monsite.fr/login' 

    # c'est cet appel à mail() qui permet d'envoyer l’e-mail en définissant destinataire et sujet.
    mail(to: @guest.email, subject: 'Bienvenue chez nous !') 
  end


  def new_registration_member(guest)
    @guest = guest
    @url  = 'http://monsite.fr/login' 
    mail(to: "francine@yopmail.com", subject: 'Nouvelle demande de membre') 
  end

end

