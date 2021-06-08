require 'rspec'
require './lib/transaction_repository'
require './lib/transaction'
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
    end
  end

  describe 'has a method that' do

    before(:each) do
      @tr.create_repo
    end

    it 'can create a repo' do

      expect(@tr.transactions.count).to eq(30)
    end

    it 'can list all transactions' do

      expect(@tr.all.count).to eq(30)
    end

    it 'can find by id' do

      expect(@tr.find_by_id(15).invoice_id).to eq(15)
      expect(@tr.find_by_id(15).credit_card_number).to eq('4556671029294436')
    end

    it 'can find all transactions by invoice id' do

      expect(@tr.find_all_by_invoice_id(15).credit_card_number).to eq('4556671029294436')
      expect(@tr.find_all_by_invoice_id(12).result).to eq('success')
    end
    it 'can find all transactions by credit card number' do

      expect(@tr.find_all_by_credit_card_number('4556671029294436').count).to eq(1)
      expect(@tr.find_all_by_credit_card_number('4556671029294436')[0].id).to eq(15)
      expect(@tr.find_all_by_credit_card_number('4556671029294436')[1]).to eq(nil)

    end
    it 'can find all by the result of the transaction' do

      expect(@tr.find_all_by_result('success').count).to eq(24)
      expect(@tr.find_all_by_result('failed').count).to eq(6)
    end

    it 'can create a new transaction' do
      @tr.create({id: "31",
                  invoice_id: "31",
                  credit_card_number: "1234223432344234",
                  credit_card_expiration_date: "0221",
                  result: 'failed',
                  created_at: '2012-02-26 20:56:56',
                  updated_at: '2012-02-26 20:56:56',
                  })
      expect(@tr.all.count).to eq(31)
      expect(@tr.all.last.credit_card_number).to eq("1234223432344234")
    end

    it 'can update an existing transaction' do
      expect(@tr.all[0].result).to eq('success')

      @tr.update(1, {   credit_card_number: "1234223432344234",
                        credit_card_expiration_date: "0221",
                        result: 'failed'})

        expect(@tr.all[0].result).to eq('failed')
        expect(@tr.all[0].credit_card_number).to eq('1234223432344234')
        expect(@tr.all[0].credit_card_expiration_date).to eq('0221')
    end

    it 'can delete a transaction' do
      expect(@tr.all.count).to eq(30)

      @tr.delete(1)

      expect(@tr.all.count).to eq(29)


    end
  end
end
