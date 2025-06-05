require "minitest/autorun"
require "csv_row"
require "pdf_file"

class TestPdfFileTest < Minitest::Test

  def setup 
    @row = CsvRow.new(date_string: "123", description: "abc", price_string: "0.99", filename: "" )   
    @pdf_file_path = "./fixtures/test.pdf"
    @pdf_file = PdfFile.new(@pdf_file_path)

  end

  def test_pdf_output_path
    assert_equal @pdf_file.output_path(@row), "./out/pdfs/#{@row.to_filename}#{File.extname(@pdf_file_path) }"
  end

end