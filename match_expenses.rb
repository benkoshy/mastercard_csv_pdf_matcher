require 'rtesseract'
require 'pdftoimage'
require 'fileutils'
require "date"
require 'csv'

require "tty-prompt"


Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file } # load ruby files

# We have a CSV file, filled with rows
# Each column has a: date, price and description
# Note how they are separated by columns.
# e.g:
# 01/03/2025,    -57.19,  SINCH MAILGUN SAN ANTONIO TX ##0325 35.48 US DOLLAR
# 04/05/2025  -8.88   COLES 0504COLES 0504 MT WAVERLEY 03
# 16/05/2025  -87.97  EG GROUP 3485 ROWVILLE VI

# We also have bunch of pdfs in a folder attached (the 'in' folder)

# our job is to match up the csv rows, with the pdfs
# (1) once we find a match: we confirm this via user input.
# (2) then we move the file to the out/pdfs/ folder
# (3) in the csv file - we add another column showing the newly renamed file.




rows = CSV.read('./in/MASTERCARD.csv')[1..-1].map do |row|
  CsvRow.new(date_string: row[0], price_string: row[1], description: row[2], filename: row[3])
end

Pathname.glob("./in/*.pdf").each_with_index do |pdf_file_path, i|
  pdf_file = PdfFile.new(pdf_file_path)
  
  pid = Process.spawn(pdf_file.command_to_open_pdf_using("mupdf")) # mupdf is what i prefer to view pdfs

    rows.each do |row|
      next if row.does_row_have_filename? || row.ignorable? # if the csv_row already has a filename listed - we can skip it. It's already been mapped.

      if File.exist?(pdf_file_path)
        if pdf_file.matches?(row)          

          if TTY::Prompt.new.yes?("\n\n\n\n Does #{row.to_filename} match with the pdf #{pdf_file_path}?")
          	Process.kill("KILL", pid)            

            row.add_filename_to_row # add to row

            FileUtils.mv(pdf_file_path, pdf_file.output_path(row))
            break
          end          
        end
      end
    end      
  Process.kill("KILL", pid)
  Process.waitpid(pid)
end

puts "Saving the csv file now....."

CSV.open("./in/MASTERCARD.csv", "w") do |f|  
  rows.each{|row| f << row.new_csv_row}
end
