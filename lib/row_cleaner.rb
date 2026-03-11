class RowCleaner

  def initialize
    @master_card = MasterCard.new
    @rows = @master_card.get_rows    
  end


  def clean_prices
  	puts "cleaning all rows from negative prices and dollar signs"
    @rows = @rows.each{|r| r.clean_price }
  end

  def save
  	puts 'Saving the csv file now.....'

    @master_card.save(@rows)
  end

end
