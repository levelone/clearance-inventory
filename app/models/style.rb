class Style < ApplicationRecord

  self.inheritance_column = :_type_disabled
  has_many :items

  TYPES = {
    dress: "Dress",
    pants: "Pants",
    scarf: "Scarf",
    sweater: "Sweater",
    top: "Top"
  }.freeze

  SPECIALS = TYPES.slice(:dress, :pants).freeze
  REGULARS = TYPES.slice(:scarf, :sweater, :top).freeze

end
