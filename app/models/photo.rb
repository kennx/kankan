#encoding: utf-8

class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :thumbnail_url,                   type: String
  field :photo_url,                       type: String
  field :statuse,                         type: String
  field :user_id,                         type: String

  attr_accessible                         :user_id, :thumbnail_url, :photo_url, :statuse

  validates_length_of                     :statuse, :maximum => 120, :allow_blank => true, :message => "SORRY，只能输入120个字符"
  validates_presence_of                   :photo_url, :message => "你没有上传任何图片"

  belongs_to                              :user, :inverse_of => :photos

end