<#PSScriptInfo
.VERSION 1.0.0
.GUID 19631007-263d-4567-b726-665727c076ce
.AUTHOR iRon
.COMPANYNAME
.COPYRIGHT
.TAGS Csv format align columns readable
.LICENSE https://github.com/iRon7/Format-Csv/LICENSE
.PROJECTURI https://github.com/iRon7/Format-Csv
.ICON
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA
#>

<#
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
#>
[CmdletBinding(DefaultParameterSetName='Html')][OutputType([Object[]])] param(
    [Parameter(ValueFromPipeLine = $True, Mandatory = $True)]$InputObject,
    [Char]$Delimiter = ',',
    [ValidateSet('Auto', 'Left', 'Right')][String]$Align = 'Auto',
    [Switch]$Quote,
    [Switch]$Tight
)

begin {
    function Quote([String]$String) {
        if ($String.Contains('"')) { '"' + $String.Replace('"', '""') + '"' }
        elseif ($Quote -or $String.Contains($Delimiter) -or ($String -match '\s')) { '"' + $String + '"' } else { $String }
    }
    function IsNumeric([String]$String) {
        [double]::TryParse($String, [ref]$Null)
    }
    $Separator = if ($Tight) { "$Delimiter" } elseif ($Quote) { " $Delimiter " } else { "$Delimiter " }
    $Column = [Ordered]@{}
    $List = [System.Collections.Generic.List[psobject]]::new()
}

process {
    if ($List.get_Count() -or $InputObject) { $List.Add($InputObject) } # Skip leading empty objects
}

end {
    if ($List.get_Count()) {
        if ($List[0] -is [String]) { $List = $List |ConvertFrom-Csv -Delimiter $Delimiter }
        $Names = @($List[0].PSObject.Properties.Where{ $_.MemberType -eq 'NoteProperty' }.Name)
        if (!$Names) { $Names = @($List[0].PSObject.Properties.Where{ $_.MemberType -eq 'Property' }.Name) }
        foreach ($Name in $Names) {
            $Header = Quote $Name
            $IsNumber = $Name -isnot [String] -and (IsNumeric $Name) # Numeric type
            $Column[$Name] = @{
                Data     = [System.Collections.Generic.List[string]]$Header
                IsNumber = [System.Collections.Generic.List[bool]]@($IsNumber) # https://github.com/PowerShell/PowerShell/issues/17731
                Width    = $Header.Length
                Left     = if ($Align -eq 'Left') { $True } elseif ($Align -eq 'Right') { $False } else { $Null }
            }
        }
        foreach ($Object in $List) {
            foreach ($Name in $Names) { 
                $Value = $Object.$Name
                $IsNumber = $Value -isnot [String] -and (IsNumeric $Value) # Numeric type
                $Column[$Name].IsNumber.Add($IsNumber)
                $String = "$Value"
                if ($Null -eq $Column[$Name].Left -and -not ($String -eq "" -or (IsNumeric $String))) { $Column[$Name].Left = $True } # Numeric string
                $String = Quote $String
                if ($Column[$Name].Width -lt $String.Length) { $Column[$Name].Width = $String.Length }
                $Column[$Name].Data.Add($String)
            }
        }
        for ($y = 0; $y -lt $Column[0].Data.Count; $y++) {
            -Join @(
                for ($x = 0; $x -lt $Names.Count; $x++) {
                    $Left = $Align -eq 'Left' -or ($Align -eq 'auto' -and $Column[$x].Left -and -not $Column[$x].IsNumber[$y])
                    $String = $Column[$x].Data[$y]
                    $Width = $Column[$x].Width
                    if ($Left) {
                        if ($x -eq $Names.Count - 1) { $String }
                        elseif ($Quote) { $String.PadRight($Width, ' ') + $Separator }
                        else { ($String + $Separator).PadRight($Width + $Separator.Length, ' ') }
                    }
                    else {
                        if ($x -eq $Names.Count - 1) { $String.PadLeft($Width, ' ') }
                        else { $String.PadLeft($Width, ' ') + $Separator }
                    }
                }
            )
        }
    }
}

