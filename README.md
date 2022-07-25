# Format-Csv

.SYNOPSIS
Formats (aligns) a Csv table

.DESCRIPTION
This cmdlet makes a Csv file or list better human readable by aligning the columns in a way that the resulted
Csv format is still a valid as input for the ConvertFrom-Csv cmdlet.

.INPUTS
Csv (here) string or object list

.OUTPUTS
String[]

.PARAMETER InputObject
    Specifies the CSV strings to be formatted or the objects that are converted to CSV formatted strings.
    You can also pipe objects to ConvertTo-CSV.

.PARAMETER Align
    Specifies the alignment of the columns
    * Left  - to align all the columns to the left
    * Right - to align all the columns to the Right
    * Auto  - to autmatically align each cell depending on the column and cell contents

    When autmatic alignment is set, the whole column is aligned to the right if all cells are numeric. Besides,
    each individual cell that contains a number type (e.g. integer) will also aligned to the right.

.PARAMETER Delimiter
    Specifies the delimiter to separate the property values in CSV strings. The default is a comma (,).
    Enter a character, such as a colon (:). To specify a semicolon (;) enclose it in single quotation marks.

.PARAMETER Quote
    Quotes all the headers and values. If the Quote switch is set, all the delimeters are aligned.
    (By default, each value is directly followed by a delimiter for compatibility reasons.)

.PARAMETER Tight
    This switch will remove the leading space (only added when the -Quote switch is set) and trailing space
    attached to each delimiter.

.LINK
    https://github.com/iRon7/Format-Csv
