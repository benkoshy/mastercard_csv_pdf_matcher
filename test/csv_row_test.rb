require "minitest/autorun"
require "csv_row"
require "test_helper"

class CSVRowTest < Minitest::Test

  def setup
    # input
    # 07/05/2025 -155.39 HEROKU* APR-102668913 SAN FRANCISCCA ##0525 100.01 US DOLLAR
    @row = CsvRow.new(date_string: "07/05/2025", price_string: "-155.39", description: "HEROKU* APR-102668913 SAN FRANCISCCA ##0525 100.01 US DOLLAR", filename: "")
  end

  def test_file_output_name        
    assert_equal "2025-05-07 - 155.39 - HEROKU* APR-102668913 SAN FRANCISCCA ##0525 100.01 US DOLLAR", @row.to_filename
  end


  def test_csv_row_dollar_matches_pdf_filename
     assert @row.match_pdf_name?("2025-08-07 - 155.39 100.01 USD - heroku")    
  end

  def test_csv_row_dollar_matches_pdf_filename_without_decimals
     assert @row.match_pdf_name?("2025-08-07 - 155 100.01 USD - heroku")    
  end

  def test_csv_row_general_name_matches_pdf_filename
    @row = CsvRow.new(date_string: "07/05/2025", price_string: "-155.39", description: "IINET LTD N SYDNEY", filename: "")
     assert @row.match_pdf_name?("iinet - 94.99 - sept 5 - invoice-15")    
  end
end