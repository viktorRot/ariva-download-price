Set-ExecutionPolicy Unrestricted
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols


foreach($line in Get-Content $PSScriptRoot\"ISIN_List.txt") {

$URI = "http://www.ariva.de/{0}/historische_kurse" -f $line

$HTML = try {Invoke-WebRequest -Uri $URI} catch { 
$_.Exception.Response 
continue
}

$SECU_ID = $HTML.ParsedHtml.getElementsByName("secu") | Select-Object -ExpandProperty value


$DOWNLAOD_URL = "http://www.ariva.de/quote/historic/historic.csv?secu={0}&clean_split=1&clean_payout=0&clean_bezug=1&min_time=01.01.2010&max_time=20.10.2017&trenner=%3B&go=Download" -f $SECU_ID.split('\s+')[0]
$FILE_PATH = "$PSScriptRoot\Output ISIN\{0}.csv" -f $line.ToString()


$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($DOWNLAOD_URL, $FILE_PATH)

If ((Get-Item Microsoft.PowerShell.Core\FileSystem::$FILE_PATH).length -le 56){

Remove-Item Microsoft.PowerShell.Core\FileSystem::$FILE_PATH

}
}


