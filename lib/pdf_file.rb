require 'pdf-reader'

# trigger file path only when required.


class PdfFile

  PDF_INPUT_DIRECTORY_GLOB = "./in/*.pdf"  
  PDF_OUTPUT_DIRECTORY_NAME = "out"

  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def matches?(csv_row)
    ## refactor this
    # return true if csv_row.match_pdf_name?(pdf_name)
    # return true if matches_with_heading?(csv_row.description) # this is good for items e.g. usa items with costs notwed in the description column of the csv row

    return true if matches_with_text?(csv_row.price)

    return matches_with_images?(csv_row)
  end

  def matches_with_heading?(description)
    @full_text = get_full_text if (@full_text.nil? || @full_text.empty? )

    captures = description.scan(/[0-9]*\.[0-9]{2}/)

    return false if captures.empty?

    captures.each do |dollar_number|
      return true if @full_text.match?(/(\$#{dollar_number})|(#{dollar_number})/)
    end
  end

  def matches_with_text?(price)
    @full_text = get_full_text if (@full_text.nil? || @full_text.empty? )

    return @full_text.match?(/(\$#{price})|(#{price})/)
  end

  def get_full_text
    reader = PDF::Reader.new(@file_path)

    full_text = ""

    reader.pages.each do |page|
      full_text << page.text
    end

    return full_text.strip
  end

  def matches_with_images?(price)
    @image_paths, @image_texts = set_up_image_variables if (@image_paths.nil? || @image_texts.nil?)

    if @image_texts.any?{ |image_text| image_text.match?(/(\$#{price})|(#{price})/)}
      return true
    else
      return false
    end
  end

  def set_up_image_variables
    @image_paths = []
    @image_texts = []

    PDFToImage.open(@file_path) do |page|
      pdf_file_name = File.basename(@file_path, File.extname(@file_path))
      image_path = "#{PDF_OUTPUT_DIRECTORY_NAME}/#{pdf_file_name}-#{page.page}.jpg"
      page.save(image_path)
      @image_paths << image_path
    end

    @image_paths.each do |image_path|
      image = RTesseract.new(image_path)
      @image_texts << image.to_s # Getting the value
    end

    return @image_paths, @image_texts
  end


  def output_path(row)
    "./#{PDF_OUTPUT_DIRECTORY_NAME}/pdfs/#{row.to_filename}#{File.extname(@file_path) }"
  end

  def command_to_open_pdf_using(program)
    "#{program} #{@file_path.to_s.shellescape}"
  end


  def pdf_name
    File.basename(@file_path, ".*")
  end

  def exists?
    File.exist?(@file_path)
  end

  def move_to_output_directory(row)
    FileUtils.mv(@file_path, output_path(row))
  end

  def self.get_input_pdfs
    Pathname.glob(PDF_INPUT_DIRECTORY_GLOB).map{|pdf_file_path| PdfFile.new(pdf_file_path) }
  end  

end
