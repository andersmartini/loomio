class GroupSubdomainConstraint
  def self.matches?(request)
    request.subdomain.present? && (request.subdomain != 'www') && (request.subdomain != 'godasamtal') #Almedalen hack
  end
end

