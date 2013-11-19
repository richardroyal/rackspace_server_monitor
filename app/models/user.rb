class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable #, :registerable,

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :role_ids

  ALL_ROLES = ['admin']

  # Associations
  has_and_belongs_to_many :servers

  # Validations
  validates :name, :email, :presence => true
  
end
