class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :thumbnail_url,                   type: String
  field :photo_url,                       type: String
  field :statuse,                         type: String
  field :user_id,                         type: String

  belongs_to                              :user

end