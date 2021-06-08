require 'simplecov'
SimpleCov.start
require 'rspec'
require './lib/invoice_item'
require 'bigdecimal'

RSpec.describe InvoiceItem do
  describe 'instantiation' do
    it 'creates a new invoice item' do
      ii = InvoiceItem.new({
                            :id => 6,
                            :item_id => 7,
                            :invoice_id => 8,
                            :quantity => 1,
                            :unit_price => BigDecimal(10.99, 4),
                            :created_at => Time.now,
                            :updated_at => Time.now
                          },self)

      expect(ii).to be_an_instance_of(InvoiceItem)
    end

    it "has readable attributes" do
      ii = InvoiceItem.new({
                            :id => "6",
                            :item_id => "7",
                            :invoice_id => "8",
                            :quantity => "1",
                            :unit_price => BigDecimal(10.99, 4),
                            :created_at => Time.now,
                            :updated_at => Time.now
                          },self)

      expect(ii.id).to eq(6)
      expect(ii.item_id).to eq(7)
      expect(ii.invoice_id).to eq(8)
      expect(ii.quantity).to eq(1)
      expect(ii.unit_price).to eq(0.1099e0)
      expect(ii.created_at.to_i).to eq(Time.now.to_i)
      expect(ii.updated_at.to_i).to eq(Time.now.to_i)
    end
  end

  describe "it's methods" do
    it "can convert unit price to dollars" do
      ii = InvoiceItem.new({
        :id => 6,
        :item_id => 7,
        :invoice_id => 8,
        :quantity => 1,
        :unit_price => BigDecimal(10.99, 4),
        :created_at => Time.now,
        :updated_at => Time.now
      },self)

      expect(ii.unit_price_to_dollars).to eq(0.11)
    end

    it 'can change quantity' do
      ii = InvoiceItem.new({
        :id => 6,
        :item_id => 7,
        :invoice_id => 8,
        :quantity => 1,
        :unit_price => BigDecimal(10.99, 4),
        :created_at => Time.now,
        :updated_at => Time.now
      },self)

      ii.change_quantity("8")

      expect(ii.quantity).to eq(8)
    end

    it 'can change unit price' do
      ii = InvoiceItem.new({
        :id => 6,
        :item_id => 7,
        :invoice_id => 8,
        :quantity => 1,
        :unit_price => BigDecimal(10.99, 4),
        :created_at => Time.now,
        :updated_at => Time.now
      },self)

      ii.change_unit_price("2500")

      expect(ii.unit_price).to eq(0.25e2)
    end

    it 'can update time' do
      ii = InvoiceItem.new({
        :id => 6,
        :item_id => 7,
        :invoice_id => 8,
        :quantity => 1,
        :unit_price => BigDecimal(10.99, 4),
        :created_at => Time.now,
        :updated_at => Time.now
      },self)

      ii.update_time

      expect(ii.updated_at.to_i).to eq(Time.now.to_i)
    end
  end

end
