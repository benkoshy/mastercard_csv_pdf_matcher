require "bigdecimal"
require 'date'

class CsvRow

	attr_reader :price, :description, :price_in_decimals

	
	def initialize(date_string:, description:, price_string: , filename: )
		@date_string = date_string
		@date = DateTime.parse(date_string.gsub(/\s+/, " ").strip)
		@description = description.gsub(/\s+/, " ").strip
		@price = "%.2f" % absolute_price_in_decimal(price_string)		
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

	def add_skip_to_row
		@filename = "skip"
	end	

	def to_filename
		return "#{@date.strftime("%Y-%m-%d")} - #{@price} - #{@description[0..100]}"
	end

	def to_s
		to_filename
	end

	def can_skip?
		does_row_have_filename? || ignorable?
	end


	def does_row_have_filename?
		return ! @filename.nil?
	end

	def ignorable?
		ignore_transactions = ["INTNL TRANSACTION FEE", "MONTHLY FEE", "PAYMENT RECEIVED, THANK YOU", "CBA OTHER CASH ADV FEE"]

		ignore_transactions.any?{ |description| description == @description.upcase }
	end

	def match_pdf_name?(pdf_name)
		# test all the words too
		return true if does_price_match?(pdf_name)

		return true if description_matches?(pdf_name)
	end

	def does_price_match?(pdf_name)
		pdf_name_without_date = pdf_name.gsub(/\d{2,4}-\d{1,2}-\d{1,2}/, '')
		pdf_name_without_date.include?("%.2f" % absolute_price_in_decimal(@price)) 		
	end

	private

	def absolute_price_in_decimal(price_string)
		BigDecimal(price_string.strip).abs
	end

	

	def description_matches?(pdf_name)
		description_words = @description.split(" ")
		pdf_words = pdf_name.split(" ")

		description_words.each do |description_word|
			pdf_words.each do |pdf_word|
				return true if pdf_word.downcase == description_word.downcase
			end
		end

		return false
	end
end