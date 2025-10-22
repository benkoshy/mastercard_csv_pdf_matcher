# require "./csv_row"

class MasterCard

	MASTERCARD_CSV_FILE_PATH = "./in/MASTERCARD.csv"
	
	def get_rows
		return CSV.read(MASTERCARD_CSV_FILE_PATH)[1..-1].map do |row|
  			CsvRow.new(date_string: row[0], price_string: row[1], description: row[2], filename: row[3])
		end
	end

	def save(rows)
		CSV.open(MASTERCARD_CSV_FILE_PATH, 'w') do |f|
	      rows.each { |row| f << row.new_csv_row }
	    end
	end

end