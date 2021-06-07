require 'rspec'
require './lib/transaction_repository'
require './lib/sales_engine'
require 'simplecov'
SimpleCov.start

RSpec.describe TransactionRepository do
  before(:each) do
    @se = SalesEngine.from_csv({
      :items => './spec/fixtures/item_mock.csv',
      :merchants => './spec/fixtures/merchant_mock.csv',
      :invoices => './spec/fixtures/invoices_mock.csv',
      :invoice_items => './spec/fixtures/invoice_items_mock.csv',
      :customers => './spec/fixtures/customers_mock.csv',
      :transactions => './spec/fixtures/transactions_mock.csv'})
    @tr = TransactionRepository.new('./spec/fixtures/transactions_mock.csv', @se)
  end

  describe 'instantiation' do
    it 'exists' do

      expect(@tr).to be_an_instance_of(TransactionRepository)
    end

    it 'has readable attributes' do

      expect(@tr.transactions.count).to eq(0)
      expect(@tr.transactions).to eq([])

      @tr.create_repo

      expect(@tr.transactions.count).to eq(30)
      expect(@tr.transactions[].id).to eq()

    end
  end
end
