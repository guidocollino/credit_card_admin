require 'aero_agency_client/version'
require 'active_resource'

module AeroAPI
   class Agency < ActiveResource::Base
    #self.site = "http://localhost:5555/api/v1"
    self.site = "http://10.0.0.169:9093/api/v1"
   end

end
