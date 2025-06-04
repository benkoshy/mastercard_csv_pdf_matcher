require "minitest/autorun"
require "csv_row"

class TestCSVRow < Minitest::Test

  def setup
    # input
    # 07/05/2025 -155.39 HEROKU* APR-102668913 SAN FRANCISCCA ##0525 100.01 US DOLLAR
    @row = CsvRow.new(date_string: "07/05/2025", price_string: "-155.39", description: "HEROKU* APR-102668913 SAN FRANCISCCA ##0525 100.01 US DOLLAR", filename: "")
  end

  def test_file_output_name        
    assert_equal "2025-05-07 - 155.39 - HEROKU* APR-102668913 SAN FRANCISCCA ##0525 100.01 US DOLLAR", @row.to_filename
  end

end