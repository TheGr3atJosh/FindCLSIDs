$ErrorActionPreference = "Stop"          
                                                                                                                      
if (-not (Get-PSDrive -Name HKCR -ErrorAction SilentlyContinue)) {
    New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}                                           
                                                           
Write-Output "Looking for CLSIDs..."
$CLSID = @()     
Foreach($ID in (Get-ItemProperty HKCR:\clsid\* -ErrorAction SilentlyContinue | Select-Object AppID,@{N='CLSID'; E={$_.pschildname}})){
    if ($ID.appid -ne $null){
        $CLSID += $ID
    }        
}     
                                                           
Write-Output "Looking for APIDs..."
$APPID = @()                
Foreach($AID in (Get-ItemProperty HKCR:\appid\* -ErrorAction SilentlyContinue | Select-Object localservice,@{N='AppID'; E={$_.pschildname}})){
    if ($AID.LocalService -ne $null){
        $APPID += $AID      
    }
}

Write-Output "Joining CLSIDs and APIDs..."
$RESULT = @()
Foreach ($app in $APPID){
    Foreach ($CLS in $CLSID){
        if($CLS.AppId -eq $app.AppID){
            $RESULT += New-Object psobject -Property @{
                AppId        = $app.AppId
                LocalService = $app.LocalService
                CLSID        = $CLS.CLSID
            }
            break
        }
    }
}

$RESULT = $RESULT | Sort-Object LocalService

Write-Output "Testing Running Services for COM Activation..."
$RESULT | ForEach-Object { 
    $entry = $_
    try { 
        $svc = Get-Service -Name $entry.LocalService -ErrorAction Stop

        if ($svc.Status -eq "Running") { 
            try { 
                [System.Activator]::CreateInstance([Type]::GetTypeFromCLSID($entry.CLSID.Trim("{}"))) | Out-Null
                Write-Output "$($entry.LocalService) | $($entry.CLSID) | Activate OK" 
            } catch { 
                if ($_.Exception.Message -match "80070005") { 
                    $r = "Access Denied" 
                } elseif ($_.Exception.Message -match "80040111") { 
                    $r = "Class Not Available" 
                } elseif ($_.Exception.Message -match "80070422") { 
                    $r = "Service Disabled" 
                } else { 
                    $r = "Failed" 
                }
                Write-Output "$($entry.LocalService) | $($entry.CLSID) | $r" 
            } 
        } 
    } catch {
    } 
}
