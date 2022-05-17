class User < ApplicationRecord
  ROLES = %i[admin doctor patient]

  after_create :create_user_profiles
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

   validates :phone, uniqueness: true, format: { with: /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{2,3})?\)?[- ]?\d{3}[- ]?\d{4}\z/,
                              message: 'Wrong phone number format'}

   def email_required?
     false
   end

   def email_changed?
     false
   end

   def create_user_profiles
     case role
     when 0
       #Admin
     when 1
       Doctor.create!( user_id: id, doctor_category_id: 1 )
       # redirect_to root_path
     when 2
       Patient.create!( user_id: id )
     else
       #Exception
       raise Exception.new "Error Role"
     end
   end

end
