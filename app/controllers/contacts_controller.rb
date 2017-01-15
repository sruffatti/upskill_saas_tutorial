class ContactsController < ApplicationController
  
  #GET request to /contact-us
  #Show new contact form
  def new
    @contact = Contact.new
  end
  
  #POST request /contacts
  def create
    #Mass assignment of form fields to Contact object
    @contact = Contact.new(contact_params)
      if @contact.save
        #Lifting from contact form ([:contact]) and grabbing name, email, and comments. Then plugging
        #into ContactMailer.contact_email(name, email, body)
        name = params[:contact][:name]
        email = params[:contact][:email]
        body = params[:contact][:comments]
        ContactMailer.contact_email(name, email, body).deliver
        #Flash notice for successful save to database. 
        #Success comes from bootstrap. Flash method is in application.html.erb
        flash[:success] = "Message sent."
        redirect_to new_contact_path
        
      else
        flash[:danger] = @contact.errors.full_messages.join(", ")
        redirect_to new_contact_path
      end
  end
  
  #To collect data from form, we need to use
  # strong parameters and whitelist the form fields
  private
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end