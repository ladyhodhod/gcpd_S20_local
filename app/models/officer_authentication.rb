module OfficerAuthentication 

  # For authentication
  ROLES = [['Commissioner', :commish],['Unit Chief', :chief],['Officer', :officer]].freeze

  def role?(authorized_role)
    return false if role.nil?
    role.downcase.to_sym == authorized_role
  end
  
  # login by username
  def Officer.authenticate(username, password)
    find_by_username(username).try(:authenticate, password)
  end 

end