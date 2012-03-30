class Selectvalue < ActiveRecord::Base
  def getMonth
     Date.today.month
  end
end