### What is this?

* It's a tool to help with bookkeeping.
* I need to map an entry (or a row) on a CSV file (basically a mastercard.csv file) with its associated pdf (which are receipts / invoices). These invoices are placed in the `in` folder. But they are not appropriately named. It is difficult to match them with particular line item or row in the csv file.

The tool:

1. matches the pdf files (located in the `in` director) with a particular row in the csv file, and
2. renames the pdf files and moves them to an `out` folder, 
3. so that we can easily search and identify them.

Each matched csv row will list the renamed file in the fourth column.

We match using a combination of regex, and various gems to extract out text from the pdf. If that fails then we OCR the pdf text.

### Detailed Explanations

We have a CSV file, filled with rows

Each column has a: date, price and description

Note the following, and how they are separated by commas:

`01/03/2025,    -57.19,  SINCH MAILGUN SAN ANTONIO TX ##0325 35.48 US DOLLAR
04/05/2025  -8.88   COLES 0504COLES 0504 MT WAVERLEY 03
16/05/2025  -87.97  EG GROUP 3485 ROWVILLE VI`

We also have bunch of pdfs in a folder attached (the 'in' folder) our job is to match up the csv rows, with the pdfs

(1) once we find a match: we confirm this via user input.

(2) then we move the file to the `out/pdfs/` folder

(3) in the csv file - we add another column showing the newly renamed file.

### Instructions

1. Get a CSV file - download this feed from your bank.
2. Place your pdf receipts in your `in` folder.
3. The code will move everything to the `out` folder.


This renames pdfs according to entries contained in a CSV file.

There are three modes of search.

1. The first searches file names of the pdf file with on purely price. i.e. we get the price entry of the csv row, and match it with a price in the pdf.
2. the second seeks to match any word in the pdf file with a word in the csv description.
3. This seeks to find the csv price within the contents of the pdf itself.

When you are happy - save the file.

### Installation

`bundle install`

`rake setup`

`ruby match_expenses.rb` to run the code.

And then either say `yes / y` or `no /n`.


### To-do

* Add tests.
* Set-up tests in terms of particular rake tasks.
* Package this gem into a command line utility.



