require 'simplecov'
SimpleCov.start
require 'rspec'
require 'bigdecimal'
require './lib/invoice_item_repository'

RSpec.describe InvoiceItemRepository do
  before :each do
    @se = SalesEngine.from_csv({
      :items => './spec/fixtures/item_mock.csv',
      :merchants => './spec/fixtures/merchant_mock.csv',
      :invoices => './spec/fixtures/invoices_mock.csv',
      :invoice_items => './spec/fixtures/invoice_items_mock.csv',
      :customers => './spec/fixtures/customers_mock.csv',
      :transactions => './spec/fixtures/transactions_mock.csv'})
    @iir = InvoiceItemRepository.new('./spec/fixtures/invoice_items_mock.csv', @se)
  end
  context 'instantiation' do
    it 'exists' do
      expect(@iir).to be_a(InvoiceItemRepository)
    end

    it 'can create a repo' do
      expect(@iir.invoice_items).to eq([])

      @iir.create_repo

      expect(@iir.invoice_items.count).to eq(90)
    end
  end
  
  context 'has a method that can' do
    it 'return all invoice items' do
      @iir.create_repo

      expect(@iir.all.count).to eq(90)
    end

    it 'find by id' do
      @iir.create_repo

      expect(@iir.find_by_id(12).invoice_id).to eq(3)
    end

    it 'find all by item id' do
      @iir.create_repo

      expect(@iir.find_all_by_item_id(263401045).count).to eq(6)
    end

    it 'find all by invoice id' do
      @iir.create_repo

      expect(@iir.find_all_by_invoice_id(3).count).to eq(10)
    end

    it 'create invoice items with readable attributes' do
      @iir.create_repo
      expect(@iir.all.count).to eq(90)

      @iir.create({
                    item_id: '263401045',
                    invoice_id: '31',
                    unit_price: '30000',
                    quantity: '6'
                    })

      expect(@iir.find_by_id(91).invoice_id).to eq(31)
    end

    it 'update an invoice item' do
      @iir.create_repo
      expect(@iir.all.count).to eq(90)

      @iir.create({
        item_id: '263401045',
        invoice_id: '31',
        unit_price: '30000',
        quantity: '6'
      })
      @iir.update(91, {
        quantity: '8',
        unit_price: '21000'
      })

      expect(@iir.find_by_id(91).quantity).to eq(8)
      expect(@iir.find_by_id(91).unit_price).to eq(0.21e3)
    end

    it 'can delete an invoice item' do
      @iir.create_repo
      expect(@iir.all.count).to eq(90)

      @iir.create({
        item_id: '263401045',
        invoice_id: '31',
        unit_price: '30000',
        quantity: '6'
      })

      @iir.delete(91)

      expect(@iir.find_by_id(91)).to eq(nil)
    end
  end
end
