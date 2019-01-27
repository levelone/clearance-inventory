class Item < ApplicationRecord

  CLEARANCE_PRICE_PERCENTAGE = BigDecimal.new("0.75")
  REGULAR_MIN_PRICE = 2.0
  SPECIAL_MIN_PRICE = 5.0

  STATUSES = [
    "sellable",
    "not sellable",
    "sold",
    "clearanced"
  ].freeze

  belongs_to :style
  belongs_to :clearance_batch
  delegate :name, :type, :wholesale_price, to: :style, prefix: true

  scope :sellable, -> { where(status: 'sellable') }

  validate :minimum_selling_price
  validates_inclusion_of :status, in: STATUSES, message: "must be either #{STATUSES.join(', ')}"

  def clearance!
    update_attributes!(
      status: 'clearanced',
      price_sold: style_wholesale_price * CLEARANCE_PRICE_PERCENTAGE
    )
  end

private

  def minimum_selling_price
    return self.price_sold = SPECIAL_MIN_PRICE if special_below_min_price?
    return self.price_sold = REGULAR_MIN_PRICE if regular_below_min_price?
    price_sold
  end

  def special_below_min_price?
    return unless style_id && price_sold
    Style::SPECIALS.values.include?(style_type) && (price_sold <= SPECIAL_MIN_PRICE)
  end

  def regular_below_min_price?
    return unless style_id && price_sold
    Style::REGULARS.values.include?(style_type) && (price_sold <= REGULAR_MIN_PRICE)
  end

end
