class Matcher
  def initialize
    @master_card = MasterCard.new
    @rows = @master_card.get_rows
    @match_mode = setup_match_mode
  end

  def setup_match_mode
    question = 'How do you want to match?'

    choices =
      [
        { key: 'p', name: 'on price? - match pdf_file_name on the price in a csv row entry', value: :price },
        { key: 'h', name: 'on file_name? - match pdf file name with everything in the csv_row and not just price.',
          value: :no },
        { key: 'c', name: "on content? - match the csv row price with what's inside the pdf", value: :content },
        { key: 'q', name: 'quit ', value: :quit }
      ]

    response = TTY::Prompt.new.select(question, choices)

    case response
    when :price
      :price
    when :heading
      :heading
    when :content
      :content
    when :quit
      exit
    end
  end

  def check_for_matches
    PdfFile.get_input_pdfs.each do |pdf_file|
      puts "reviwing pdf: #{pdf_file.pdf_name} - #{pdf_file.file_path}"

      catch :break do
        @rows.each do |row|
          next if row.can_skip?

          next unless pdf_file.exists? && programmatic_match?(row, pdf_file)

          case ask_if_matches(row, pdf_file)
          when :yes
            row.add_filename_to_row # add to row
            pdf_file.move_to_output_directory(row)
            throw :break
          when :no
          when :skip_pdf
            throw :break
          when :skip_row
            row.add_skip_to_row
          when :display
            display_pdf(pdf_file)
            redo
          when :quit
            exit
          end
        end
      end
    end

    puts "\n\n finished"
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

  ## This is best placed in the MasterCard Class
  def save?
    return unless TTY::Prompt.new.yes?("\n\n\n\n save to csv?")

    puts 'Saving the csv file now.....'

    @master_card.save(@rows)
  end

  private

  def display_pdf(pdf_file)
    TTY::Pager.new.page(pdf_file.display)
  end
end
