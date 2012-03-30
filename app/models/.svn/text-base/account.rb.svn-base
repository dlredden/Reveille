class Account < ActiveRecord::Base
  belongs_to :plan
  belongs_to :payment, :dependent => :destroy
  has_many :account_users, :dependent => :destroy
  has_many :users, :through => :account_users
  has_many :backpack_reminders, :dependent => :destroy
  
  def refund_amount()
    @days_left_in_current_month = Date.today().day - self.next_bill_date.day
  end
  
  def days_left()
    (self.next_bill_date - Date.today()).days
  end
  
  def cancelation_date()
    if (self.next_bill_date.day > Date.today.day)
      Date.new(Date.today.year, Date.today.month, self.next_bill_date.day)
    else
      Date.new(Date.today.year, Date.today.month, self.next_bill_date.day) + 1.month
    end
  end
end
