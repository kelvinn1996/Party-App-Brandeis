class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :drop]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  helper_method :sex_check

  def new
    #prevents user from accessing signup when already logged in
    begin
      @user = User.find(session[:user_id])
      redirect_to @user
    rescue ActiveRecord::RecordNotFound
      @user = User.new
    end
  end

  def index
    #admins only page
    if User.find(session[:user_id]).admin?
      @users = User.paginate(page: params[:page])
    else
      redirect_to root_path
    end
  end

  #profile page
  def show
     @user = User.find(params[:id])
  end

  #edit page
  def edit
    @user = User.find(params[:id])
  end

  #updating profile
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  #drop parties
  def drop
    if params[:id]
      Party.existing(current_user.id,params[:id]).first.destroy
      flash[:success] = "Sucessfully Dropped!"
      redirect_to current_user
    end
  end

  #signup page
  def create
   @user = User.new(user_params)
   if @user.save
     @user.update_attribute(:radius, 5)
     Stripe.api_key = Rails.application.secrets.STRIPE_SECRET_KEY
     customer = Stripe::Customer.create(email: @user.email)
     @user.update_attribute(:customer_id, customer.id)
     @user.update_attribute(:verify, FALSE)
     @user.update_attribute(:card_avail, FALSE)

     #defaults to 5 mile radius
     log_in @user
     flash[:success] = "Welcome to the Fiesto!"
     redirect_to @user


   else
     render 'new'
   end
 end

 #user deletion by admin
 def destroy
   Party.user_deletion(params[:id]).each do |temp|
     temp.destroy
   end
   Event.user_deletion(params[:id]).each do |temp|
     temp.destroy
   end
   User.find(params[:id]).destroy
   flash[:success] = "User deleted"
   redirect_to users_url
 end

 def expand
    if current_user != nil
      current_user.update(:radius => (current_user.radius + 2))
    end
    redirect_to '/'
 end

 def sex_check
   require 'net/http'
   require 'json'
   new_dob = Date.strptime(current_user.dob, "%m/%d/%Y")
   @url = "http://services.familywatchdog.us/rest/json.asp?key=F413B188-9C3B-4A19-A286-6BDEF26A84E1&lite=1&type=searchbynamedob&fname=" + current_user.first_name + "&lname=" + current_user.last_name + "&dob=" + new_dob.strftime("%m") + "/" + new_dob.strftime("%d") + "/" + new_dob.strftime("%Y")

   uri = URI(@url)
   response = Net::HTTP.get(uri)

   h = JSON.parse response
   if h["offenders"][0].nil?
     puts "Not an offender"
     current_user.offender = FALSE
   else
     puts "Is an offender"
     current_user.offender = TRUE
   end
   current_user.save
end

def verify
end

def verify_check
  BlockScore.api_key = 'sk_test_c09ab82974083e676772876a24482e00'

  new_dob = Date.strptime(current_user.dob, "%m/%d/%Y")
  person = BlockScore::Person.create(
    birth_day: new_dob.strftime("%d"),
    birth_month: new_dob.strftime("%m"),
    birth_year: new_dob.strftime("%Y"),
    document_type: 'ssn',
    document_value: '0000',
    name_first: current_user.first_name,
    name_last: current_user.last_name,
    address_street1: "#{params[:address_street1]}",
    address_street2: "#{params[:address_street2]}",
    address_city: "#{params[:address_city]}",
    address_subdivision: "#{params[:address_state]}",
    address_postal_code: "#{params[:address_postal_code]}",
    address_country_code: 'US'
  )

  puts person.status
  if person.status == 'valid'
    current_user.verify = TRUE
    current_user.save
  end
  flash[:success] = "Your identity will be reviewed."
  redirect_to current_user
end

 private
    def user_params
     params.require(:user).permit(:username, :email, :password, :bio,
                                  :password_confirmation, :radius, :first_name, :last_name, :dob, :passcode)
   end

   def logged_in_user
       unless logged_in?
         store_location
         flash[:danger] = "Please log in."
         redirect_to login_url
       end
   end

   # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
