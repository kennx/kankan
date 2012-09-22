class Tag
  include Mongoid::Document

  field :name,                 type: String

  has_and_belongs_to_many     :photos

  def create_tag(tags)
    tag_arrary = tags.split(" ")
    tag_arrary.each do |t|
      Tag.new(name: "#{t}")
    end
  end


end