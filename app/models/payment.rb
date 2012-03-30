class Payment < ActiveRecord::Base
  encrypt_with_public_key :number, :key_pair => File.join(RAILS_ROOT,'config','keypair.pem')
  encrypt_with_public_key :cvv_number, :key_pair => File.join(RAILS_ROOT,'config','keypair.pem')
  has_one :account
  
  validates_presence_of :name, :number, :cvv_number, :exp_month, :exp_year
  
  def cvv()
    self.cvv_number.decrypt(SB_KEY)
  end
  
  def cc_number()
    self.number.decrypt(SB_KEY)
  end
  
  def last_four_digits()
    mask_number(cc_number)
  end
  
  def mask_number(number)
    number.to_s.size < 5 ? number.to_s : (('*' * number.to_s[0..-5].length) + number.to_s[-4..-1])
  end
end
