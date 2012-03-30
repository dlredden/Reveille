require 'date'

class Reminder
	attr_accessor :id, :content, :remind_at, :creator, :remindees
	
	def initialize(rem = nil) 
		@remindees = []
    
    if (rem)
      self.parse(rem)
    end
	end
	
	def parse(reminder)
		@id = reminder["id"].to_i
		@remind_at = Time.parse(reminder["remind_at"][0])
		@content = reminder["content"]
		@creator = BackpackUser.new(reminder["creator"][0]["name"], reminder["creator"][0]["id"].to_i)
		
		reminder["remindees"][0]["user"].each { |x|
			@remindees.push(BackpackUser.new(x["name"], x["id"].to_i))
		}
  end

  def formatted_remind_at(user)
    @format = "%a %b %d"
    
    if (self.remind_at.getlocal().year != Time.now().year)
      @format += " %Y"
    end
    
    if (self.remind_at.getlocal().hour != 0 || self.remind_at.getlocal().min != 0)
      @format += " at %I:%M %p"
    end
    
    self.remind_at.strftime(@format)
  end
end