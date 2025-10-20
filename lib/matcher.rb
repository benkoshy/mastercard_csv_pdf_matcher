class Matcher


  def initialize
    @rows = MasterCard.new.get_rows
  end


  def choose_matching_style
   choices =
    [
      { key: "p", name: "on price? - match pdf_file_name on the price in a csv row entry", value: :price },
      { key: "h", name: "on heading? - match pdf file name with everything in the csv_row and not just price.", value: :no },
      { key: "c", name: "on content? - match the price with what's inside the pdf", value: :content },      
      { key: "q", name: "quit ", value: :quit }
    ]
  
	response = TTY::Prompt.new.select("How do you want to match?", choices)

	case response
	when :price
		match_price
	when :heading
		match_by_file_name
	when :content
		match_content
	when :quite
		exit
	end
  end

  def match_price # compare rows with the prices in the pdf file_name
    check_for_matches  do |row, pdf_file|
      row.does_price_match?(pdf_file.pdf_name)
    end
  end

  def match_by_file_name
    check_for_matches  do |row, pdf_file|
      row.match_pdf_name?(pdf_file.pdf_name) ## match the whole row including the words
    end
  end

  def match_content
    check_for_matches  do |row, pdf_file|
      pdf_file.matches?(row)
    end
  end


  def check_for_matches
    PdfFile.get_input_pdfs.each do |pdf_file|
      catch :throw do
        @rows.each do |row|
          next if row.can_skip?

          if pdf_file.exists?
            if yield(row, pdf_file)
              
              answer = ask_if_matches(row, pdf_file)
              respond_to_answer(answer, row, pdf_file)
            else
              print "."
            end
          end
        end
      end
    end

    puts "\n\n finished"
  end

  def respond_to_answer(answer, row, pdf_file)
    case answer
    when :yes
      row.add_filename_to_row # add to row
      pdf_file.move_to_output_directory(row)
      throw  :break
    when :no
    when :skip_pdf
      throw :break
    when :skip_row
      row.add_skip_to_row
    when :quit
      exit
    end
  end

  def ask_if_matches(row, pdf_file)
    prompt = TTY::Prompt.new(quiet: true)
    prompt.expand("#{"\n"*40} #{row.to_filename} (csv row) \n '#{pdf_file.file_path}' (file_path) \n\n", choices)
  end

  def choices
    [
      { key: "y", name: "yes - file matches", value: :yes },
      { key: "n", name: "no - file does not match ", value: :no },
      { key: "s", name: "skip_pdf ", value: :skip_pdf },
      { key: "r", name: "skip_row ", value: :skip_row },
      { key: "q", name: "quit ", value: :quit }
    ]
  end

  def save?
    if TTY::Prompt.new.yes?("\n\n\n\n save to csv?")#
      puts "Saving the csv file now....."

      CSV.open("./in/MASTERCARD.csv", "w") do |f|
        rows.each{|row| f << row.new_csv_row}
      end
    end

  end
end
