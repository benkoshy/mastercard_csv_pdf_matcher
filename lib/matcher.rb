class Matcher
  def initialize
    @master_card = MasterCard.new
    @rows = @master_card.get_rows
    @match_mode = setup_match_mode
    @pdfs = PdfFile.get_input_pdfs
  end

  def check_for_matches
    @pdfs.each do |pdf_file|
      puts "reviwing pdf: #{pdf_file.pdf_name} - #{pdf_file.file_path}"

      catch :break do
        @rows.each do |row|
          next if row.does_row_have_filename?          
          (row.record_na and next) if row.ignorable?           

          next unless pdf_file.exists? && programmatic_match?(row, pdf_file)

          case ask_if_matches(row, pdf_file)
          when :yes
            row.add_filename_to_row # add to row
            pdf_file.mark_as_move_to_output_director(row)
            throw :break
          when :no
          when :skip_pdf
            throw :break
          when :skip_row
            row.add_skip_to_row
          when :display
            display_pdf(pdf_file)         
            display_row(row) # so we remember what we're matching!?   
            redo
          when :quit
            exit
          end
        end
      end
    end

    puts "\n\n finished"
  end

  ## This is best placed in the MasterCard Class
  def save?
    return  if (!TTY::Prompt.new.yes?("\n\n\n\n save to csv?")) && (TTY::Prompt.new.yes?("\n\n\n\n Are you sure?"))

    puts 'Saving the csv file now.....'

    @master_card.save(@rows)
  end

  private

  def display_pdf(pdf_file)
    TTY::Pager.new.page(pdf_file.display)
  end

  def display_row(row)
    TTY::Pager.new.page(row.to_s)
  end

    def setup_match_mode
    question = 'How do you want to match?'

    choices =
      [
        { key: 'p', name: 'on price? - match pdf_file_name on the price in a csv row entry', value: :price },
        { key: 'h', name: 'on file_name? - match pdf file name with everything in the csv_row and not just price.',
          value: :heading },
        { key: 'c', name: "on content? - match the csv row price with what's inside the pdf", value: :content },
        { key: 'q', name: 'quit ', value: :quit }
      ]

    response = TTY::Prompt.new.select(question, choices)

    exit if response == :quite

    response
  end


  def programmatic_match?(row, pdf_file)
    case @match_mode
    when :price
      row.does_price_match?(pdf_file.pdf_name)
    when :heading      
      row.match_pdf_name?(pdf_file.pdf_name) ## match the whole row including the words
    when :content
      pdf_file.matches?(row)
    else
      exit
    end
  end

  def ask_if_matches(row, pdf_file)
    choices = [
      { key: 'y', name: 'yes - file matches', value: :yes },
      { key: 'n', name: 'no - file does not match ', value: :no },
      { key: 's', name: 'skip_pdf ', value: :skip_pdf },
      { key: 'r', name: 'skip_row ', value: :skip_row },
      { key: 'd', name: 'display ', value: :display },
      { key: 'q', name: 'quit ', value: :quit }
    ]

    prompt = TTY::Prompt.new(quiet: true)
    prompt.expand("#{"\n" * 40} #{row.to_filename} (csv row) \n '#{pdf_file.file_path}' (file_path) \n\n", choices)
  end
end
