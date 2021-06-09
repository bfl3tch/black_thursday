require 'CSV'
require 'bigdecimal'
require_relative 'sales_engine'

class SalesAnalyst
  attr_reader :engine

  def initialize(engine)
    @engine = engine
  end

  def average(data)
    data.sum / data.size.to_f
  end

  def standard_deviation(sample_size)
    Math.sqrt(sample_size.sum do |sample|
      (sample - average(sample_size)) ** 2 / (sample_size.size - 1)
    end).round(2)
  end

  def items_per_merchant
    all_items = @engine.items
    all_merchants = @engine.merchants
    all_merchants.all.map do |merchant|
      all_items.find_all_by_merchant_id(merchant.id).count
    end
  end

  def average_items_per_merchant
    average(items_per_merchant).round(2)
  end

  def average_items_per_merchant_standard_deviation
    standard_deviation(items_per_merchant)
  end

  def high_item_count
    standard_deviation(items_per_merchant) + average_items_per_merchant
  end

  def merchants_with_high_item_count
    all_items = @engine.items
    all_merchants = @engine.merchants.all
    all_merchants.map do |merchant|
      if all_items.find_all_by_merchant_id(merchant.id).count >= high_item_count
        merchant
      end
    end.compact
  end

  def average_item_price_for_merchant(merchant_id)
    all_items = @engine.items
    unit_prices = all_items.find_all_by_merchant_id(merchant_id).map do |item|
      item.unit_price
    end
    average(unit_prices).round(2)
  end

  def average_average_price_per_merchant
    all_merchants = @engine.merchants.all
    all_merchant_averages = all_merchants.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    average(all_merchant_averages).round(2)
  end

  def golden_items
    all_items_unit_prices = @engine.items.all.map { |item| item.unit_price }
    stan_div = standard_deviation(all_items_unit_prices) * 2
    avg = average(all_items_unit_prices)
    @engine.items.all.find_all do |item|
      item.unit_price >= (stan_div + avg)
    end
  end

  def invoices_per_merchant
    all_invoices = @engine.invoices
    all_merchants = @engine.merchants
    all_merchants.all.map do |merchant|
      all_invoices.find_all_by_merchant_id(merchant.id).count
    end
  end

  def average_invoices_per_merchant
    average(invoices_per_merchant).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviation(invoices_per_merchant).round(2)
  end

  def high_invoice_count
    (standard_deviation(invoices_per_merchant) * 2) + average_invoices_per_merchant
  end

  def top_merchants_by_invoice_count
    all_invoices = @engine.invoices
    all_merchants = @engine.merchants.all
    all_merchants.map do |merchant|
      if all_invoices.find_all_by_merchant_id(merchant.id).count >= high_invoice_count
        merchant
      end
    end.compact
  end

  def low_invoice_count
    lv = average_invoices_per_merchant - (standard_deviation(invoices_per_merchant) * 2)
    lv.round(2)
  end

  def bottom_merchants_by_invoice_count
    all_invoices = @engine.invoices
    all_merchants = @engine.merchants.all
    all_merchants.map do |merchant|
      if all_invoices.find_all_by_merchant_id(merchant.id).count <= low_invoice_count
        merchant
      end
    end.compact
  end

  def assign_invoice_day
    all_invoices = @engine.invoices.all
    vars = all_invoices.map do |invoice|
      Time.parse(invoice.created_at)
    end
    day = vars.map do |var|
      var.strftime('%A')
    end
  end

  def tally_the_days
    assign_invoice_day.tally
  end

  def mean_number_of_invoices_per_day
    total = tally_the_days.values.sum
    total.fdiv(7).round(2)
  end

  def standard_deviation_of_days
    array = []
    tally_the_days.values.each do |value|
    array << value
    end
    standard_deviation(array)
  end

  def top_days_by_invoice_count
    result = (standard_deviation_of_days) + (mean_number_of_invoices_per_day)
    tally_the_days.find_all do |day, amount|
      if amount > result
        return day
      end
    end
  end

  def invoice_status(status)
    all_invoices = @engine.invoices.all
    all_stats = []
    all_invoices.each do |invoice|
      if invoice.status.to_sym == status
        all_stats << invoice.status.to_sym
        end
      end
      amount_of_stat = all_stats.count
      (amount_of_stat.fdiv(all_invoices.count) * 100).round(1)
  end

  def invoice_paid_in_full?(invoice_id)
    successful_transactions = []
    all_transactions = @engine.transactions.all
    all_transactions.find_all do |transaction|
     if transaction.result == :success
       successful_transactions << transaction.invoice_id
      end
    end
    successful_transactions.include?(invoice_id)
  end

  def invoice_total(invoice_id)
    ii = @engine.invoice_items.all
    matches = []
    total_amounts = []
    ii.each do |invoiceitem|
      if invoiceitem.invoice_id == invoice_id
        matches << invoiceitem
        end
        matches.each do |match|
          total_amounts << (match.unit_price * match.quantity)
        end
      end
      total_amounts.uniq.sum
  end
end
