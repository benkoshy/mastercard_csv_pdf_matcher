class Solutions


	def initialize
		@solutions = []
	end


	def add(row, pdf)		
		@solutions.push({row: row, pdf: pdf})
	end


	def pop
		row_and_pdf_hash = @solutions.pop

		row = row_and_pdf_hash[:row]
		pdf = row_and_pdf_hash[:pdf]

		puts "\nWe are popping #{row.to_s}, and clearing pdf #{pdf.to_s}"

		row.clear_filename
		pdf.unmark_pdf
	end

end