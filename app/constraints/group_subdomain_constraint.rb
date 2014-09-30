class GroupSubdomainConstraint
  def self.matches?(request)
    if ENV['HOST_SUBDOMAIN']
       request.subdomain.present? && (request.subdomain != ENV['HOST_SUBDOMAIN'])
    else
    	request.subdomain.present? && (request.subdomain != 'www')
    end
  end
end

