require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :account_users, :dependent => :destroy
  has_many :accounts, :through => :account_users
  
  validates_presence_of :first_name, :last_name, :email, :password
  validates_uniqueness_of :email
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 8
  validates_length_of :first_name, :within => 1..25
  validates_length_of :last_name, :within => 1..40
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/io
  
  attr_accessor :password
  attr_protected :hashed_password, :salt
  
  def before_create()
    self.salt = User.make_salt(self.email)
    self.hashed_password = User.hash_with_salt(@password, self.salt)
  end
  
  def before_update()
    if (!@password.blank? && @password != "BLANK PASSWORD FOR UPDATE OF USER")
      self.salt = User.make_salt(self.email) if self.salt.blank?
      self.hashed_password = User.hash_with_salt(@password, self.salt)
    end
  end
  
  def after_save()
    @password = nil
  end
  
  def before_destroy()
    # Don't destroy if this user belongs to more than one account
    return false if (self.account_users.size > 1)
  end
  
  # Returns the user's first name and last name joined with a space.
  def full_name()
    self.first_name + " " + self.last_name
  end
  
  def self.generate_password()
    @chars =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten - ['o','O','0','1','l','i','I']
    (0..8).map{ @chars[rand(@chars.length)]  }.join
  end
  
  def self.authenticate(email = "", password = "")
    user = self.find(:first, :conditions => {:email => email})
    return (user && user.authenticated?(password)) ? user : nil
  end
  
  def authenticated?(password = "")
    self.hashed_password == User.hash_with_salt(password, self.salt)
  end
  
  private #----------------
  
  def self.make_salt(string)
    return Digest::SHA1.hexdigest(string.to_s + Time.now.to_s)
  end
  
  def self.hash_with_salt(password, salt)
    return Digest::SHA1.hexdigest("Put #{salt} on the #{password}")
  end
end
