# Format-Csv
Formats (aligns) a Csv table
## [Syntax](#syntax)
```PowerShell
Format-Csv
    [[-InputObject] <Object>]
    [-Delimiter <Char>]
    [-Align <String>]
    [-Quote]
    [-Tight]
    [<CommonParameters>]
```
## [Description](#description)
 This cmdlet makes a Csv file or list better human readable by aligning the columns in a way that the resulted  
Csv format is still a valid as input for the ConvertFrom-Csv cmdlet.

## [Examples](exampls)
### Example 1
PS > 
```PowerShell
$Csv = @'
"Name","Number","Object","Remark"
"One","1","Text","Normal"
"Two","2","123","Number"
"Three","3","Te,xt","Comma in Text"
"Four","4","Te""xt","Double quote in text"
,,,"Empty ($Null)"
"Five","5","More","Normal"
'@
	
$Csv |Format-Csv
Name,  Number, Object,   Remark
One,        1, Text,     Normal
Two,        2, 123,      Number
Three,      3, "Te,xt",  "Comma in Text"
Four,       4, "Te""xt", "Double quote in text"
,            , ,         "Empty ($Null)"
Five,       5, More,     Normal
```
## [Parameters](#parameters)
### `-InputObject`
 Specifies the CSV strings to be formatted or the objects that are converted to CSV formatted strings.  
You can also pipe objects to ConvertTo-CSV.

| <!--                    --> | <!-- --> |
| --------------------------- | -------- |
| Type:                       | [Object](https://docs.microsoft.com/en-us/dotnet/api/System.Object) |
| Position:                   | 1 |
| Default value:              |  |
| Accept pipeline input:      | true (ByValue) |
| Accept wildcard characters: | false |
### `-Delimiter`
 Specifies the delimiter to separate the property values in CSV strings. The default is a comma (,).  
Enter a character, such as a colon (:). To specify a semicolon (;) enclose it in single quotation marks.

| <!--                    --> | <!-- --> |
| --------------------------- | -------- |
| Type:                       | [Char](https://docs.microsoft.com/en-us/dotnet/api/System.Char) |
| Position:                   | 2 |
| Default value:              | , |
| Accept pipeline input:      | false |
| Accept wildcard characters: | false |
### `-Align`
 Specifies the alignment of the columns  
* Left  - to align all the columns to the left  
* Right - to align all the columns to the Right  
* Auto  - to autmatically align each cell depending on the column and cell contents  
  
When autmatic alignment is set, the whole column is aligned to the right if all cells are numeric. Besides,  
each individual cell that contains a number type (e.g. integer) will also aligned to the right.

| <!--                    --> | <!-- --> |
| --------------------------- | -------- |
| Accepted values:            | Auto, Left, Right |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/System.String) |
| Position:                   | 3 |
| Default value:              | Auto |
| Accept pipeline input:      | false |
| Accept wildcard characters: | false |
### `-Quote`
 Quotes all the headers and values. If the Quote switch is set, all the delimeters are aligned.  
(By default, each value is directly followed by a delimiter for compatibility reasons.)

| <!--                    --> | <!-- --> |
| --------------------------- | -------- |
| Type:                       | [SwitchParameter](https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.SwitchParameter) |
| Position:                   | named |
| Default value:              | False |
| Accept pipeline input:      | false |
| Accept wildcard characters: | false |
### `-Tight`
 This switch will remove the leading space (only added when the -Quote switch is set) and trailing space  
attached to each delimiter.

| <!--                    --> | <!-- --> |
| --------------------------- | -------- |
| Type:                       | [SwitchParameter](https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.SwitchParameter) |
| Position:                   | named |
| Default value:              | False |
| Accept pipeline input:      | false |
| Accept wildcard characters: | false |
## [Inputs](#inputs)
### Csv (here) string or object list
## [Outputs](#outputs)
### [String[]](https://docs.microsoft.com/en-us/dotnet/api/System.String[])
## [Related Links](#related-links)
* [https://github.com/iRon7/Format-Csv](https://github.com/iRon7/Format-Csv)
