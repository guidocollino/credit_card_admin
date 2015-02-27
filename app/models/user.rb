class User  
  attr_accessor :id, :name_and_surname, :email, :username, :agency_id

  def initialize(username, id,  name_and_surname, email, agency_id)
    self.username = username
    self.id = id
    self.name_and_surname = name_and_surname
    self.email = email
    self.agency_id = agency_id
  end

end