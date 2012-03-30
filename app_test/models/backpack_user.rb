class BackpackUser
	attr_accessor :name, :id
  
  def initialize(name = nil, id = nil)
    @name = name
    @id = id
  end
end