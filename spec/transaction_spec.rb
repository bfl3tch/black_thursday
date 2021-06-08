require 'rspec'
require 'time'
require './lib/transaction_repository'
require './lib/transaction'
require './lib/sales_engine'
require 'simplecov'
SimpleCov.start

RSpec.describe Transaction do
  before(:each) do
  @repo_double = double("item_repo")
  @transaction = Transaction.new({
    id: "31",
    invoice_id:  "31",
    credit_card_number: "1234223432344234",
    credit_card_expiration_date: "0221",
    result: "failed",
    created_at: "2016-01-11 11:34:30 UTC",
    updated_at: "2017-03-24 02:37:51 UTC"
    }, @repo_double)
  end
  describe 'instantiation' do
    it 'exists' do

      expect(@transaction).to be_an_instance_of(Transaction)
    end

    it 'has readable attributes' do
      expect(@transaction.id).to eq(31)
      expect(@transaction.result).to eq('failed')
      expect(@transaction.credit_card_number).to eq("1234223432344234")
      expect(@transaction.invoice_id).to eq(31)

    end
  end
  describe 'has a method that' do
    it 'can update the time' do
      expect(@transaction.updated_at).to eq('2017-03-24 02:37:51 UTC')

      @transaction.update_time

      expect(@transaction.updated_at).to be_a(String)
      expect(@transaction.updated_at > '2017-03-24 02:37:51 UTC').to be(true)
    end

    it 'can change the credit card number' do
      expect(@transaction.credit_card_number).to eq("1234223432344234")

      @transaction.change_credit_card_number("5555666677778888")

      expect(@transaction.credit_card_number).to eq("5555666677778888")
    end

    it 'can change the credit card expiration date' do
      expect(@transaction.credit_card_expiration_date).to eq("0221")

      @transaction.change_credit_card_expiration_date("0224")

      expect(@transaction.credit_card_expiration_date).to eq("0224")
    end

    it 'can update the result' do
      expect(@transaction.result).to eq("failed")

      @transaction.update_result("success")

      expect(@transaction.result).to eq("success")
    end
  end
end
