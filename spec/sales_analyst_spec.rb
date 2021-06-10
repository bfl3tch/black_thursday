require 'simplecov'
SimpleCov.start
require 'rspec'
require './lib/sales_analyst'

RSpec.describe 'SalesAnalyst' do
  before(:each) do
    @se = SalesEngine.from_csv({
      :items => './spec/fixtures/item_mock.csv',
      :merchants => './spec/fixtures/merchant_mock.csv',
      :invoices => './spec/fixtures/invoices_mock.csv',
      :invoice_items => './spec/fixtures/invoice_items_mock.csv',
      :customers => './spec/fixtures/customers_mock.csv',
      :transactions => './spec/fixtures/transactions_mock.csv'})
    @sa = SalesAnalyst.new(@se)
  end
  describe 'instantiation (iteration 1)' do
    it 'exists' do

      expect(@sa).to be_a(SalesAnalyst)
    end
  end

  describe 'has a method that' do
    it 'can calculate an average' do

      expect(@sa.average([7, 8, 9, 10, 11])).to eq(9)
      expect(@sa.average([2, 45, 23, 32])).to eq(25.5)
      expect(@sa.average([5, 7, 9, 4, 4])).to eq(5.8)
    end

    it 'can calculate standard deviation' do

      expect(@sa.standard_deviation([7, 8, 9, 10, 11])).to eq(1.58)
      expect(@sa.standard_deviation([2, 45, 23, 32])).to eq(18.08)
      expect(@sa.standard_deviation([5, 7, 9, 4, 4])).to eq(2.17)
    end

    it 'can calculate the number of items per merchant' do

      expect(@sa.items_per_merchant).to eq([5, 7, 9, 4, 4])
    end

    it 'can calculate average items per merchant' do

      expect(@sa.average_items_per_merchant).to eq(5.8)
    end

    it 'can calculate average items per merchant standard deviation' do

      expect(@sa.average_items_per_merchant_standard_deviation).to eq(2.17)
    end

    it 'can calculate merchants with a high item count' do

      expect(@sa.merchants_with_high_item_count.count).to eq(1)
    end

    it 'can determine the average item price per merchant' do

      expect(@sa.average_item_price_for_merchant(12334123)).to eq(0.11e3)
    end

    it 'can calculate the average of the averages per merchant' do

      expect(@sa.average_average_price_per_merchant).to eq(0.3735e2)
    end

    it 'can calculate the golden items which are 2 standevs above mean' do

      expect(@sa.golden_items.count).to eq(2)
    end
  end
  context '(iteration 2)' do
    it 'can find invoices per merchant' do
      expect(@sa.invoices_per_merchant).to eq([4, 6, 2, 10, 14])
    end

    it 'can calculate the average invoices per merchant' do
      expect(@sa.average_invoices_per_merchant).to eq(7.2)
    end

    it 'can calculate average invoices per merchant standard deviation' do
      expect(@sa.average_invoices_per_merchant_standard_deviation).to eq(4.82)
    end

    it 'can calculate high invoice count' do
      expect(@sa.high_invoice_count).to eq(16.84)
    end

    it 'can find top merchants by invoice count' do
      expect(@sa.top_merchants_by_invoice_count).to eq([])
    end

    it 'can calculate low invoice count' do
      expect(@sa.low_invoice_count).to eq(-2.44)
    end

    it 'can find bottom merchants by invoice count' do
      expect(@sa.bottom_merchants_by_invoice_count).to eq([])
    end

    it 'can assign invoices a day value' do
      expect(@sa.assign_invoice_day.count).to eq(36)
    end

    it 'can tally up each of the day values individually' do
      expect(@sa.assign_invoice_day.count).to eq(36)
      expect(@sa.tally_the_days).to eq(
        { "Friday"=>8,
          "Monday"=>6,
          "Saturday"=>6,
          "Sunday"=>4,
          "Thursday"=>5,
          "Tuesday"=>5,
          "Wednesday"=>2
        })
    end

    it 'can determine the average invoices per day' do
      expect(@sa.mean_number_of_invoices_per_day).to eq(5.14)
    end

    it 'can determine the standard deviation of the weekday set' do
      expect(@sa.standard_deviation_of_days).to eq(1.86)
    end

    it 'can calculate the top days by invoice count' do
      expect(@sa.top_days_by_invoice_count).to eq('Friday')
    end

    it 'can determine the invoice status of percentage by status' do
      expect(@sa.invoice_status(:pending)).to eq(38.9)
      expect(@sa.invoice_status(:shipped)).to eq(58.3)
      expect(@sa.invoice_status(:returned)).to eq(2.8)
    end

    it 'can determine if the invoice is paid in full' do
      expect(@sa.invoice_paid_in_full?(8)).to eq(true)
      expect(@sa.invoice_paid_in_full?(9)).to eq(false)
    end

    it 'can determine the total amount owed by invoice' do
      expect(@sa.invoice_total(8)).to eq(0.637047e4)
      expect(@sa.invoice_total(1)).to eq(0.1645131e5)
    end

    it "can determines total revenue by date" do
      expect(@sa.total_revenue_by_date("2012-03-27")).to eq(254792.59)
    end

    it 'can determine revenue by invoice id' do
      expect(@sa.revenue_by_invoice_id(5)).to eq(4912.1)
    end

    it 'can return revenue by merchant' do
      expect(@sa.revenue_by_merchant(12334123)).to eq(58859.75)
    end
  end
end
