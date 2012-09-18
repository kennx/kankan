require 'digest/sha2'

class User

  include Mongoid::Document

  field :uid,                       type: String
  field :username,                  type: String
  field :avatar,                    type: String
  field :gender,                    type: Boolean
  field :location,                  type: String
  field :description,               type: String

  has_many                          :photos


end