require 'rspec'
require './lib/sales_engine'
require './lib/merchant_repository'
require './lib/item_repository'
require 'simplecov'
SimpleCov.start

RSpec.describe do
  describe 'instantiation' do
    it 'creates a new sales engine' do
      se = SalesEngine.from_csv({
        :items => './spec/fixtures/item_fixtures.csv',
        :merchants => './spec/fixtures/merchant_fixtures.csv'
        })

      expect(se).to be_an_instance_of(SalesEngine)
    end
  end

  describe 'its methods' do
    it 'can list all merchants' do
      item_repository = ItemRepository.new('./data/items.csv', self).create_repo
      merchant_repository = MerchantRepository.new('./spec/fixtures/merchant_fixtures.csv', self).create_repo
      se = SalesEngine.from_csv({
        :items => './spec/fixtures/item_fixtures.csv',
        :merchants => './spec/fixtures/merchant_fixtures.csv'
        })

      expect(se.merchants) == (merchant_repository)
    end

    it 'can find merchant by id' do
      se = SalesEngine.from_csv({
        :items => './spec/fixtures/item_fixtures.csv',
        :merchants => './spec/fixtures/merchant_fixtures.csv'
        })

        expect(se.find_merchant_by_id(12334382).name).to eq("Keckenbauer")
    end

    it 'can list all the items' do
      @item_repository = ItemRepository.new('./data/items.csv', self).create_repo
      se = SalesEngine.from_csv({
        :items => './spec/fixtures/item_fixtures.csv',
        :merchants => './spec/fixtures/merchant_fixtures.csv'
        })
        expect(se.items) == (@item_repository)
    end

    it 'can find items by id' do
      se = SalesEngine.from_csv({
        :items => './spec/fixtures/item_fixtures.csv',
        :merchants => './spec/fixtures/merchant_fixtures.csv'
        })

        expect(se.find_item_by_id(263408574).name).to eq("Adidas Azteca Fußballschuh")
    end

    it 'can create a sales analyst class' do
      se = SalesEngine.from_csv({
        :items => './spec/fixtures/item_fixtures.csv',
        :merchants => './spec/fixtures/merchant_fixtures.csv'
        })

      expect(se.analyst).to be_an_instance_of(SalesAnalyst)

    end
  end
end
