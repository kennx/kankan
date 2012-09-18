class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :origina,                         type: String
  field :thumbnail,                       type: String
  field :middle,                          type: String
  field :statuse,                         type: String
  field :user_id,                         type: String

  belongs_to                              :user

end