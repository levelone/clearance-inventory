require 'rails_helper'

describe Item do
  describe "#perform_clearance!" do

    let(:wholesale_price) { 100 }
    let(:item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style, wholesale_price: wholesale_price)) }

    before do
      item.clearance!
      item.reload
    end

    it "should mark the item status as clearanced" do
      expect(item.status).to eq("clearanced")
    end

    it "should set the price_sold as 75% of the wholesale_price" do
      expect(item.price_sold).to eq(BigDecimal.new(wholesale_price) * BigDecimal.new("0.75"))
    end
  end

  describe "#minimum_selling_price" do

    context "when special style is below minimum price" do
      let(:wholesale_price) { 4.5 }
      let(:style) { FactoryGirl.create(:style, type: Style::SPECIALS.values[0], wholesale_price: wholesale_price) }
      let(:item) { FactoryGirl.create(:item, style: style) }

      before do
        item.price_sold = wholesale_price * Item::CLEARANCE_PRICE_PERCENTAGE
      end

      it "returns special minimum price" do
        expect(Style::SPECIALS.values).to include item.style_type
        expect(item.price_sold).to be <= Item::SPECIAL_MIN_PRICE
        item.save!
        expect(item.price_sold).to eq Item::SPECIAL_MIN_PRICE
      end
    end

    context "when regular style is below minimum price" do
      let(:wholesale_price) { 1.5 }
      let(:style) { FactoryGirl.create(:style, type: Style::REGULARS.values[0], wholesale_price: wholesale_price) }
      let(:item) { FactoryGirl.create(:item, style: style) }

      before do
        item.price_sold = wholesale_price * Item::CLEARANCE_PRICE_PERCENTAGE
      end

      it "returns regular minimum price" do
        expect(Style::REGULARS.values).to include item.style_type
        expect(item.price_sold).to be <= Item::REGULAR_MIN_PRICE
        item.save!
        expect(item.price_sold).to eq Item::REGULAR_MIN_PRICE
      end
    end

    context "when any style is above minimum price" do
      let(:wholesale_price) { 10 }
      let(:style) { FactoryGirl.create(:style, type: Style::TYPES.values[0], wholesale_price: wholesale_price) }
      let(:item) { FactoryGirl.create(:item, style: style) }

      before do
        item.price_sold = wholesale_price * Item::CLEARANCE_PRICE_PERCENTAGE
      end

      it "returns price when above minimum price" do
        expect(Style::TYPES.values).to include item.style_type
        expect(item.price_sold).to be >= Item::REGULAR_MIN_PRICE
        expect(item.price_sold).to be >= Item::SPECIAL_MIN_PRICE
        item.save!
        expect(item.price_sold).not_to eq Item::REGULAR_MIN_PRICE
        expect(item.price_sold).not_to eq Item::SPECIAL_MIN_PRICE
        expect(item.price_sold).to eq 7.5
      end
    end

  end
end
