require_relative 'test_helper'

class CSVRowTest < Minitest::Test
  def setup
    # input
    # 07/05/2025 -155.39 HEROKU* APR-102668913 SAN FRANCISCCA ##0525 100.01 US DOLLAR
    @row = CsvRow.new(date_string: '07/05/2025', price_string: '-155.39',
                      description: 'HEROKU* APR-102668913 SAN FRANCISCCA ##0525 100.01 US DOLLAR', filename: '')
  end

  def test_file_output_name
    assert_equal '2025-05-07 - 155.39 - HEROKU* APR-102668913 SAN FRANCISCCA ##0525 100.01 US DOLLAR', @row.to_filename
  end

  def test_csv_row_dollar_matches_pdf_filename
    assert @row.match_pdf_name?('2025-08-07 - 155.39 100.01 USD - heroku')
  end

  def test_csv_row_dollar_matches_pdf_filename_without_decimals
    assert @row.match_pdf_name?('2025-08-07 - 155 100.01 USD - heroku')
  end

  def test_csv_row_general_name_matches_pdf_filename
    @row = CsvRow.new(date_string: '07/05/2025', price_string: '-155.39', description: 'IINET LTD N SYDNEY',
                      filename: '')
    assert @row.match_pdf_name?('iinet - 94.99 - sept 5 - invoice-15')
  end

  def test_csv_row_price_matches_pdf_filename_1
    @row = CsvRow.new(date_string: '29/07/2025', price_string: '202', description: 'REMITLY* B72C7 Sydney',
                      filename: '')
    refute @row.match_pdf_name?('20250726 REMITLY 202') # we need decimal places
  end

  def test_csv_row_price_matches_pdf_filename_2
    @row = CsvRow.new(date_string: '29/07/2025', price_string: '202', description: 'REMITLY* B72C7 Sydney', filename: '')
    assert @row.match_pdf_name?('20250729 202.00 REMITLY')
  end

  def test_match_3
    @row = CsvRow.new(date_string: '03/03/26', price_string: '16.98', description: 'AMAZON AU MARKETPLACE SYDNEY', filename: '')    
    assert @row.does_price_match?("16.98 - Tek1 Pty Ltd Mail - Ordered_ .pdf") 
  end

  def test_match_3
    @row = CsvRow.new(date_string: '03/03/26', price_string: '16.98', description: 'AMAZON AU MARKETPLACE SYDNEY', filename: '')    
    assert @row.does_price_match?("16.98 - Tek1 Pty Ltd Mail - Ordered_ .pdf") 
  end
end
