require "bigdecimal"

class CsvRow

	attr_reader :price, :description

	
	def initialize(date_string:, description:, price_string: , filename: )
		@date_string = date_string
		@date = DateTime.parse(date_string.gsub(/\s+/, " ").strip)
		@description = description.gsub(/\s+/, " ").strip
		@price = ("%.2f" % (BigDecimal(price_string.gsub(/\s+/, " ").strip).abs))
		@filename = filename
	end

	def new_csv_row
		if @filename.nil? || @filename.strip.empty? 
			[@date_string, @price, @description]
		else
			[@date_string, @price, @description, @filename]
		end
	end

	## filename

	def add_filename_to_row
		@filename = to_filename
	end

	def does_row_have_filename?
		return ! @filename.nil?
	end

	def to_filename
		return "#{@date.strftime("%Y-%m-%d")} - #{@price} - #{@description[0..100]}"
	end
end