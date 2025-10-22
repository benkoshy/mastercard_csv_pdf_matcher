require 'rtesseract'
require 'pdftoimage'
require 'fileutils'
require "date"
require 'csv'

require "tty-prompt"
require "debug"

require 'tty-pager'


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


### Somtimes we might have a CSV entry like this:
# 24/07/2025	15.93	PAYPAL *KAVALRYPTEL 31254310 SGP ## SGP MERCHANT
## so we might want to match a pdf named "Kavalry"
## meaning that the word must be contained anywhere in the text.

matcher = Matcher.new
matcher.save?
