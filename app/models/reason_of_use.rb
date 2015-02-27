class ReasonOfUse
  include Mongoid::Document
  field :name, type: String
  field :priority, type: Integer
  field :description, type: String
end
