#Requires -Modules @{ModuleName="Pester"; ModuleVersion="5.0.0"}

Set-StrictMode -Version Latest

$MyPath = [System.IO.FileInfo]$MyInvocation.MyCommand.Path
$AliasName = [System.IO.Path]::GetFileNameWithoutExtension($MyPath.Name) -Replace '\.Tests$'
$ScriptName = [System.IO.Path]::ChangeExtension($AliasName, 'ps1')
$ScriptPath = Join-Path $MyPath.DirectoryName $ScriptName

Write-Host 123 $ScriptPath

Set-Alias -Name $AliasName -Value $ScriptPath

Describe 'Format-Csv' {

    BeforeAll {

        $TestTable =
        [pscustomobject]@{ Name = 'One';   Number = 1;     Object = 'Text'  ; Remark = 'Normal' },
        [pscustomobject]@{ Name = 'Two';   Number = 2;     Object = 123     ; Remark = 'Number' },
        [pscustomobject]@{ Name = 'Three'; Number = 3;     Object = 'Te,xt' ; Remark = 'Comma in Text' },
        [pscustomobject]@{ Name = 'Four';  Number = 4;     Object = 'Te"xt' ; Remark = 'Double quote in text' },
        [pscustomobject]@{ Name = $Null;   Number = $Null; Object = $Null   ; Remark = 'Empty ($Null)' },
        [pscustomobject]@{ Name = 'Five';  Number = 5;     Object = 'More'  ; Remark = 'Normal' }

    }

    Context '(default)' {

        It 'From PSCustomObject list' {

            $Actual = $TestTable |Format-Csv
            $Expected = @(
                'Name,  Number, Object,   Remark',
                'One,        1, Text,     Normal',
                'Two,        2,      123, Number',
                'Three,      3, "Te,xt",  "Comma in Text"',
                'Four,       4, "Te""xt", "Double quote in text"',
                ',            , ,         "Empty ($Null)"',
                'Five,       5, More,     Normal'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }

        It 'Round Trip' {

            $Objects = $TestTable |Format-Csv |ConvertFrom-Csv
            $Actual = $Objects |Format-Csv
            $Expected = @(
                'Name,  Number, Object,   Remark',
                'One,        1, Text,     Normal',
                'Two,        2, 123,      Number',
                'Three,      3, "Te,xt",  "Comma in Text"',
                'Four,       4, "Te""xt", "Double quote in text"',
                ',            , ,         "Empty ($Null)"',
                'Five,       5, More,     Normal'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }

        It 'From csv lines' {

            $CsvLines = $TestTable |ConvertTo-Csv
            $Actual = $CsvLines |Format-Csv
            $Expected = @(
                'Name,  Number, Object,   Remark',
                'One,        1, Text,     Normal',
                'Two,        2, 123,      Number',
                'Three,      3, "Te,xt",  "Comma in Text"',
                'Four,       4, "Te""xt", "Double quote in text"',
                ',            , ,         "Empty ($Null)"',
                'Five,       5, More,     Normal'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }


        It 'From csv here-string' {

            $CsvString = ($TestTable |ConvertTo-Csv) -Join "`r`n"
            $Actual = $CsvString |Format-Csv
            $Expected = @(
                'Name,  Number, Object,   Remark',
                'One,        1, Text,     Normal',
                'Two,        2, 123,      Number',
                'Three,      3, "Te,xt",  "Comma in Text"',
                'Four,       4, "Te""xt", "Double quote in text"',
                ',            , ,         "Empty ($Null)"',
                'Five,       5, More,     Normal'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }

        It 'From formatted Csv' {

            $FormatCsv = $TestTable |Format-Csv
            $Actual = $FormatCsv |Format-Csv
            $Expected = @(
                'Name,  Number, Object,   Remark',
                'One,        1, Text,     Normal',
                'Two,        2, 123,      Number',
                'Three,      3, "Te,xt",  "Comma in Text"',
                'Four,       4, "Te""xt", "Double quote in text"',
                ',            , ,         "Empty ($Null)"',
                'Five,       5, More,     Normal'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }
    }
    Context 'Test table -Quote' {

        It 'From PSCustomObject list' {

            $Actual = $TestTable |Format-Csv -Quote
            $Expected = @(
                '"Name"  , "Number" , "Object" , "Remark"',
                '"One"   ,      "1" , "Text"   , "Normal"',
                '"Two"   ,      "2" ,    "123" , "Number"',
                '"Three" ,      "3" , "Te,xt"  , "Comma in Text"',
                '"Four"  ,      "4" , "Te""xt" , "Double quote in text"',
                '""      ,       "" , ""       , "Empty ($Null)"',
                '"Five"  ,      "5" , "More"   , "Normal"'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }

        It 'Round Trip' {

            $Objects = $TestTable |Format-Csv -Quote |ConvertFrom-Csv
            $Actual = $Objects |Format-Csv -Quote
            $Expected = @(
                '"Name"  , "Number" , "Object" , "Remark"',
                '"One"   ,      "1" , "Text"   , "Normal"',
                '"Two"   ,      "2" , "123"    , "Number"',
                '"Three" ,      "3" , "Te,xt"  , "Comma in Text"',
                '"Four"  ,      "4" , "Te""xt" , "Double quote in text"',
                '""      ,       "" , ""       , "Empty ($Null)"',
                '"Five"  ,      "5" , "More"   , "Normal"'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }

        It 'From csv lines' {

            $CsvLines = $TestTable |ConvertTo-Csv
            $Actual = $CsvLines |Format-Csv -Quote
            $Expected = @(
                '"Name"  , "Number" , "Object" , "Remark"',
                '"One"   ,      "1" , "Text"   , "Normal"',
                '"Two"   ,      "2" , "123"    , "Number"',
                '"Three" ,      "3" , "Te,xt"  , "Comma in Text"',
                '"Four"  ,      "4" , "Te""xt" , "Double quote in text"',
                '""      ,       "" , ""       , "Empty ($Null)"',
                '"Five"  ,      "5" , "More"   , "Normal"'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }


        It 'From csv here-string' {

            $CsvString = ($TestTable |ConvertTo-Csv) -Join "`r`n"
            $Actual = $CsvString |Format-Csv -Quote
            $Expected = @(
                '"Name"  , "Number" , "Object" , "Remark"',
                '"One"   ,      "1" , "Text"   , "Normal"',
                '"Two"   ,      "2" , "123"    , "Number"',
                '"Three" ,      "3" , "Te,xt"  , "Comma in Text"',
                '"Four"  ,      "4" , "Te""xt" , "Double quote in text"',
                '""      ,       "" , ""       , "Empty ($Null)"',
                '"Five"  ,      "5" , "More"   , "Normal"'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }

        It 'From formatted Csv' {

            $FormatCsv = $TestTable |Format-Csv -Quote
            $Actual = $FormatCsv |Format-Csv -Quote
            $Expected = @(
                '"Name"  , "Number" , "Object" , "Remark"',
                '"One"   ,      "1" , "Text"   , "Normal"',
                '"Two"   ,      "2" , "123"    , "Number"',
                '"Three" ,      "3" , "Te,xt"  , "Comma in Text"',
                '"Four"  ,      "4" , "Te""xt" , "Double quote in text"',
                '""      ,       "" , ""       , "Empty ($Null)"',
                '"Five"  ,      "5" , "More"   , "Normal"'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }
    }

    Context 'Test table -Delimiter' {

        It 'From PSCustomObject list' {

            $Actual = $TestTable |Format-Csv -Delimiter '|'
            $Expected = @(
                'Name|  Number| Object|   Remark',
                'One|        1| Text|     Normal',
                'Two|        2|      123| Number',
                'Three|      3| Te,xt|    "Comma in Text"',
                'Four|       4| "Te""xt"| "Double quote in text"',
                '|            | |         "Empty ($Null)"',
                'Five|       5| More|     Normal'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }

        It 'Round Trip' {

            $Objects = $TestTable |Format-Csv -Delimiter '|' |ConvertFrom-Csv -Delimiter '|'
            $Actual = $Objects |Format-Csv -Delimiter '|'
            $Expected = @(
                'Name|  Number| Object|   Remark',
                'One|        1| Text|     Normal',
                'Two|        2| 123|      Number',
                'Three|      3| Te,xt|    "Comma in Text"',
                'Four|       4| "Te""xt"| "Double quote in text"',
                '|            | |         "Empty ($Null)"',
                'Five|       5| More|     Normal'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }
    }

    Context 'Test table -Quote -Delimiter' {

        It 'From PSCustomObject list' {

            $Actual = $TestTable |Format-Csv -Quote -Delimiter '|'
            $Expected = @(
                '"Name"  | "Number" | "Object" | "Remark"',
                '"One"   |      "1" | "Text"   | "Normal"',
                '"Two"   |      "2" |    "123" | "Number"',
                '"Three" |      "3" | "Te,xt"  | "Comma in text"',
                '"Four"  |      "4" | "Te""xt" | "Double quote in text"',
                '""      |       "" | ""       | "Empty ($Null)"',
                '"Five"  |      "5" | "More"   | "Normal"'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }

        It 'Round Trip' {

            $Objects = $TestTable |Format-Csv -Quote -Delimiter '|' |ConvertFrom-Csv -Delimiter '|'
            $Actual = $Objects |Format-Csv -Quote -Delimiter '|'
            $Expected = @(
                '"Name"  | "Number" | "Object" | "Remark"',
                '"One"   |      "1" | "Text"   | "Normal"',
                '"Two"   |      "2" | "123"    | "Number"',
                '"Three" |      "3" | "Te,xt"  | "Comma in text"',
                '"Four"  |      "4" | "Te""xt" | "Double quote in text"',
                '""      |       "" | ""       | "Empty ($Null)"',
                '"Five"  |      "5" | "More"   | "Normal"'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }
    }

    Context 'Test table -Tight' {

        It 'From PSCustomObject list' {

            $Actual = $TestTable |Format-Csv -Tight
            $Expected = @(
                'Name, Number,Object,  Remark',
                'One,       1,Text,    Normal',
                'Two,       2,     123,Number',
                'Three,     3,"Te,xt", "Comma in Text"',
                'Four,      4,"Te""xt","Double quote in text"',
                ',           ,,        "Empty ($Null)"',
                'Five,      5,More,    Normal'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }

        It 'Round Trip' {

            $Objects = $TestTable |Format-Csv -Tight |ConvertFrom-Csv
            $Actual = $Objects |Format-Csv -Tight
            $Expected = @(
                'Name, Number,Object,  Remark',
                'One,       1,Text,    Normal',
                'Two,       2,123,     Number',
                'Three,     3,"Te,xt", "Comma in Text"',
                'Four,      4,"Te""xt","Double quote in text"',
                ',           ,,        "Empty ($Null)"',
                'Five,      5,More,    Normal'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }
    }

    Context 'Test table -Quote -Tight' {

        It 'From PSCustomObject list' {

            $Actual = $TestTable |Format-Csv -Quote -Tight
            $Expected = @(
                '"Name" ,"Number","Object","Remark"',
                '"One"  ,     "1","Text"  ,"Normal"',
                '"Two"  ,     "2",   "123","Number"',
                '"Three",     "3","Te,xt" ,"Comma in text"',
                '"Four" ,     "4","Te""xt","Double quote in text"',
                '""     ,      "",""      ,"Empty ($Null)"',
                '"Five" ,     "5","More"  ,"Normal"'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }

        It 'Round Trip' {

            $Objects = $TestTable |Format-Csv -Quote -Tight |ConvertFrom-Csv
            $Actual = $Objects |Format-Csv -Quote -Tight
            $Expected = @(
                '"Name" ,"Number","Object","Remark"',
                '"One"  ,     "1","Text"  ,"Normal"',
                '"Two"  ,     "2","123"   ,"Number"',
                '"Three",     "3","Te,xt" ,"Comma in text"',
                '"Four" ,     "4","Te""xt","Double quote in text"',
                '""     ,      "",""      ,"Empty ($Null)"',
                '"Five" ,     "5","More"  ,"Normal"'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }
    }

    Context 'Test table -Align Left' {

        It 'From PSCustomObject list' {

            $Actual = $TestTable |Format-Csv -Align Left
            $Expected = @(
                'Name,  Number, Object,   Remark',
                'One,   1,      Text,     Normal',
                'Two,   2,      123,      Number',
                'Three, 3,      "Te,xt",  "Comma in Text"',
                'Four,  4,      "Te""xt", "Double quote in text"',
                ',      ,       ,         "Empty ($Null)"',
                'Five,  5,      More,     Normal'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }

        It 'Round Trip' {

            $Objects = $TestTable |Format-Csv -Align Left |ConvertFrom-Csv
            $Actual = $Objects |Format-Csv -Align Left
            $Expected = @(
                'Name,  Number, Object,   Remark',
                'One,   1,      Text,     Normal',
                'Two,   2,      123,      Number',
                'Three, 3,      "Te,xt",  "Comma in Text"',
                'Four,  4,      "Te""xt", "Double quote in text"',
                ',      ,       ,         "Empty ($Null)"',
                'Five,  5,      More,     Normal'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }
    }

    Context 'Test table -Quote -Align Left' {

        It 'From PSCustomObject list' {

            $Actual = $TestTable |Format-Csv -Quote -Align Left
            $Expected = @(
                '"Name"  , "Number" , "Object" , "Remark"',
                '"One"   , "1"      , "Text"   , "Normal"',
                '"Two"   , "2"      , "123"    , "Number"',
                '"Three" , "3"      , "Te,xt"  , "Comma in Text"',
                '"Four"  , "4"      , "Te""xt" , "Double quote in text"',
                '""      , ""       , ""       , "Empty ($Null)"',
                '"Five"  , "5"      , "More"   , "Normal"'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }

        It 'Round Trip' {

            $Objects = $TestTable |Format-Csv -Quote -Align Left |ConvertFrom-Csv
            $Actual = $Objects |Format-Csv -Quote -Align Left
            $Expected = @(
                '"Name"  , "Number" , "Object" , "Remark"',
                '"One"   , "1"      , "Text"   , "Normal"',
                '"Two"   , "2"      , "123"    , "Number"',
                '"Three" , "3"      , "Te,xt"  , "Comma in Text"',
                '"Four"  , "4"      , "Te""xt" , "Double quote in text"',
                '""      , ""       , ""       , "Empty ($Null)"',
                '"Five"  , "5"      , "More"   , "Normal"'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }
    }

    Context 'Test table -Align Right' {

        It 'From PSCustomObject list' {

            $Actual = $TestTable |Format-Csv -Align Right
            $Expected = @(
                ' Name, Number,   Object,                 Remark',
                '  One,      1,     Text,                 Normal',
                '  Two,      2,      123,                 Number',
                'Three,      3,  "Te,xt",        "Comma in Text"',
                ' Four,      4, "Te""xt", "Double quote in text"',
                '     ,       ,         ,        "Empty ($Null)"',
                ' Five,      5,     More,                 Normal'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }

        It 'Round Trip' {

            $Objects = $TestTable |Format-Csv -Align Right |ConvertFrom-Csv
            $Actual = $Objects |Format-Csv -Align Right
            $Expected = @(
                ' Name, Number,   Object,                 Remark',
                '  One,      1,     Text,                 Normal',
                '  Two,      2,      123,                 Number',
                'Three,      3,  "Te,xt",        "Comma in Text"',
                ' Four,      4, "Te""xt", "Double quote in text"',
                '     ,       ,         ,        "Empty ($Null)"',
                ' Five,      5,     More,                 Normal'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }
    }

    Context 'Test table -Quote -Align Right' {

        It 'From PSCustomObject list' {

            $Actual = $TestTable |Format-Csv -Quote -Align Right
            $Expected = @(
                ' "Name" , "Number" , "Object" ,               "Remark"',
                '  "One" ,      "1" ,   "Text" ,               "Normal"',
                '  "Two" ,      "2" ,    "123" ,               "Number"',
                '"Three" ,      "3" ,  "Te,xt" ,        "Comma in Text"',
                ' "Four" ,      "4" , "Te""xt" , "Double quote in text"',
                '     "" ,       "" ,       "" ,        "Empty ($Null)"',
                ' "Five" ,      "5" ,   "More" ,               "Normal"'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }

        It 'Round Trip' {

            $Objects = $TestTable |Format-Csv -Quote -Align Right |ConvertFrom-Csv
            $Actual = $Objects |Format-Csv -Quote -Align Right
            $Expected = @(
                ' "Name" , "Number" , "Object" ,               "Remark"',
                '  "One" ,      "1" ,   "Text" ,               "Normal"',
                '  "Two" ,      "2" ,    "123" ,               "Number"',
                '"Three" ,      "3" ,  "Te,xt" ,        "Comma in Text"',
                ' "Four" ,      "4" , "Te""xt" , "Double quote in text"',
                '     "" ,       "" ,       "" ,        "Empty ($Null)"',
                ' "Five" ,      "5" ,   "More" ,               "Normal"'
            )
            $Actual |Compare-Object $Expected |Should -BeNullOrEmpty
        }
    }
}