class Bank < ActiveResource::Base
  cached_resource :ttl => 3600#La cache expira cada un dia
    #self.site = "http://localhost:5555/api/v1"
    self.site = "http://localhost:3002/api/v1"
  end