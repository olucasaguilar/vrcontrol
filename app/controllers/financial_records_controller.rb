class FinancialRecordsController < ApplicationController
  def index
    @financial_records = FinancialRecord.all
  end
end