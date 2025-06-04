require 'pdf-reader'

class PdfFile

  def initialize(file_path)
    @file_path = file_path

    @full_text = get_full_text
    @image_paths, @image_texts = set_up_image_variables
  end


  def matches?(csv_row)   
    return true if matches_with_heading?(csv_row.description) # this is good for items e.g. usa items with costs notwed in the description column of the csv row

    return true if matches_with_text?(csv_row.price)    
    
    return matches_with_images?(csv_row)
  end

  def matches_with_heading?(description)
    captures = description.scan(/[0-9]*\.[0-9]{2}/)

    return false if captures.empty?

    captures.each do |dollar_number|
      return true if @full_text.match?(/(\$#{dollar_number})|(#{dollar_number})/)
    end
  end

  def matches_with_text?(price)
    return @full_text.match?(/(\$#{price})|(#{price})/)
  end

  def get_full_text
    reader = PDF::Reader.new(@file_path)

    full_text = ""

    reader.pages.each do |page|
      full_text << page.text
    end

    return full_text.strip
    # puts "empty in full text? #{full_text.strip.empty?}"
  end

  def set_up_image_variables
    @image_paths = []
    @image_texts = []

    PDFToImage.open(@file_path) do |page|
      pdf_file_name = File.basename(@file_path, File.extname(@file_path))      
      image_path = "#{output_directory_name}/#{pdf_file_name}-#{page.page}.jpg"      
      page.save(image_path)
      @image_paths << image_path
    end

    @image_paths.each do |image_path|
      image = RTesseract.new(image_path)
      @image_texts << image.to_s # Getting the value
    end

    return @image_paths, @image_texts
  end


  def matches_with_images?(price)
    if @image_texts.any?{ |image_text| image_text.match?(/(\$#{price})|(#{price})/)}
      return true
    else
      return false
    end
  end

  def print_text
    puts @image_texts
  end


  def rename_pdf(csv_row)
    puts "renaming to: #{output_directory_name}/#{csv_row.file_name}"
  end


  private

  def output_directory_name
    "out"
  end



end
