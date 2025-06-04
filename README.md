### What is this?

I need to map an entry on a CSV file (basically a mastercard.csv file) with its associated pdf receipts, which are placed in the `in` folder.

The result? We rename the pdf files and move them to an `out` folder, so that we can easily search and identify them.

Each matched csv row will list the renamed file in the fourth column.

### Detailed Explanations

We have a CSV file, filled with rows

Each column has a: date, price and description

Note how they are separated by columns.

e.g:
01/03/2025,    -57.19,  SINCH MAILGUN SAN ANTONIO TX ##0325 35.48 US DOLLAR
04/05/2025  -8.88   COLES 0504COLES 0504 MT WAVERLEY 03
16/05/2025  -87.97  EG GROUP 3485 ROWVILLE VI

We also have bunch of pdfs in a folder attached (the 'in' folder) our job is to match up the csv rows, with the pdfs

(1) once we find a match: we confirm this via user input.

(2) then we move the file to the out/pdfs/ folder

(3) in the csv file - we add another column showing the newly renamed file.


## WARNING: pdf files will be moved

### Instructions

1. Get a CSV file - download this feed from your bank.
2. Place your pdf receipts in your `in` folder.
3. The code will move everything to the `out` folder.
4. I'm using `mupdf` because it is light weight. You may choose to use your own reader.


`bundle install`

`rake setup`

`ruby match_expenses.rb`

And then either say `yes` or `no`.

