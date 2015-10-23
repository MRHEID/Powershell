#############################################
###        Universal IE11 Install         ###
###          Created by MRHEID            ###
###        Version 1.0  (10232015)        ###
#############################################

#   Declare Parameters

PARAM(
    [string]$3264 = "64",
    [string]$InstallRemove = "1"
    )

 #Create Log File & Folders
 $ScriptName = "Universal IE11 Install"
 $ScriptVer = "1.0"
 $TimeStamp = Get-Date
 $LogPath = $ENV:SystemRoot + "\Applogs\" + $ScriptName + ".txt"
 $AppLogs = $ENV:SystemRoot + "\AppLogs\"
 
 IF(!(Test-Path -path "$AppLogs"))
    {
    New-Item -path $Applogs -ItemType Directory
    }
 ELSE
    {}
 
 IF (!(Test-Path -Path "$LogPath"))
    {
    New-Item -path $LogPath -ItemType File
    }
 ELSE
    {
    Remove-Item $LogPath
    New-Item -path $LogPath -ItemType File
    }
 
Add-Content $LogPath "*****************************************************"
Add-content $LogPath "$ScriptName"
Add-content $LogPath "Created by MRHEID"
Add-content $LogPath "Script version $SCRIPTVER"
Add-Content $LogPath "*****************************************************"
Add-Content $LogPath "Script Start: $TimeStamp"
Add-Content $logPath "Paramater Values..."
Add-Content $logPath "    Processor Architecture: $3264 bit"
Add-Content $logPath "    Installation: $InstallRemove  (Installation=1 / Removal<>1)"
Add-Content $logPath ""
Add-Content $logPath ""
Add-Content $logPath "* * * * * * * * * *"
Add-Content $logPath ""

IF ($InstallRemove -eq "1") {

    #Verify IE Patch Detected
    Add-Content $LogPath "Verifying if Internet Explorer 11 is already installed"
    $HotFixList = Get-hotfix
    $PreReqList = "KB2841134"
    $PreReqList | ForEach-Object {
        $TEMP1 = $_
        $TEMP2 = $HotfixList | Where-Object {$_.HotfixID -eq $Temp1}
        IF($TEMP2 -ne $NULL){
        Write-host "$TEMP1 Found"
        Add-Content $LogPath "Internet Explorer Detection Complete"
        Add-Content $LogPath "Internet Explorer 11 was found."
        Add-Content $LogPath "Bypassing Installation."
        #End Script
		Add-Content $LogPath ""
        Add-Content $logPath "* * * * * * * * * *"
        Add-Content $logPath ""
		$TimeStamp = Get-Date
		Add-Content $LogPath "Script Start: $TimeStamp"
		Add-Content $logPath "Script Complete."
		Break
        }
        ELSE{
        Add-Content $LogPath "Internet Explorer Detection Complete"
        Add-Content $LogPath "Internet Explorer 11 was not detected."
        Add-Content $LogPath ""
        Add-Content $logPath "* * * * * * * * * *"
        Add-Content $logPath ""
        
        #Start Installation
        Add-Content $logPath "Starting Installation..."
        
        #Install Pre-Reqs
        Add-Content $logPath "Installing Prereqs..."
        $TEMP = ".\PreReqs\"+$3264+"\"
        $ITEMS = get-childitem $TEMP
        $NoItems = $items.count
        $i = 0
        $ITEMS | Foreach-object {
            Write-Progress -Activity "installing Pre-Reqs for IE 11" -Status "$i out of $NoItems " -percentcomplete($i/$NoItems*100)
            $ITEMNAME = $_.NAME
            Add-Content $logPath "  Installing $ITEMNAME"
            $STDOUT = $AppLogs + '\' + $ITEMNAME + '.txt'
            $STDERR = $AppLogs + '\' + $ITEMNAME + '_Errors.txt'
            $DISMARG = ' /Online /add-package /packagepath:".\Prereqs\'+ $3264 +'\'+$ITEMNAME+'" /norestart'
            start-process -filepath 'dism.exe' -argumentlist $DISMARG -erroraction stop -nonewwindow -RedirectStandardOutput $STDOUT -RedirectStandardError $STDERR -wait
            IF ((get-content $STDERR) -eq $NULL)
                {
                Remove-Item $STDERR
                }
            $i = $i + 1
            }
        Add-Content $LogPath "Pre-req Installation Complete"
        Add-Content $LogPath ""
        Add-Content $logPath "* * * * * * * * * *"
        Add-Content $logPath ""
    
        #Verify Hotfixes were installed
        Add-Content $logPath "Verifying Pre-Reqs were installed."
        $HotFixList = Get-hotfix
        $PreReqList = @("KB2533623","KB2639308","KB2670838","KB2729094","KB2731771","KB2786081","KB2834140","KB2834140","KB2882822","KB2888049")
        $PreReqList | ForEach-Object {
            $TEMP1 = $_
            IF(($HotfixList | Where-Object {$_.HotfixID -eq $Temp1}).HotFixID -eq $Temp1){
            Write-host "$TEMP1 Found" 
            }
            ELSE{
            Add-Content $logPath "Critical Error:  Cannot find $Temp1"
            Add-Content $logPath "Terminating Script"
            Throw "Cannot find prerequisite $TEMP1"
            }
        }
        Add-Content $logPath "Pre-Req Verification Complete." 
        Add-Content $LogPath ""
        Add-Content $logPath "* * * * * * * * * *"
        Add-Content $logPath ""
      
        #Install IE 11
        Add-Content $LogPath "Installing Internet Explorer 11..."
        $ITEMNAME = "IE-Win7.cab"
        Add-Content $logPath "  Installing $ITEMNAME"
        $STDOUT = $AppLogs + '\' + $ITEMNAME + '.txt'
        $STDERR = $AppLogs + '\' + $ITEMNAME + '_Errors.txt'
        $DISMARG = '/online /add-package /packagepath:".\IE11\'+$3264+'\IE-Win7.cab" /norestart'
        Start-process -filepath 'dism.exe'-argumentlist $DISMARG -erroraction stop -nonewwindow -RedirectStandardOutput $STDOUT -RedirectStandardError $STDERR -wait
        IF ((get-content $STDERR) -eq $NULL)
            {
            Remove-Item $STDERR
            }
        Add-Content $logPath "Internet Explorer 11 Installation Complete." 
        Add-Content $LogPath ""
        Add-Content $logPath "* * * * * * * * * *"
        Add-Content $logPath ""
        
        #Verify IE Patch Detected
        Add-Content $LogPath "Verifying Internet Explorer 11 has installed"
        $HotFixList = Get-hotfix
        $PreReqList = "KB2841134"
        $PreReqList | ForEach-Object {
            $TEMP1 = $_
            $TEMP2 = $HotfixList | Where-Object {$_.HotfixID -eq $Temp1}
            IF($TEMP2 -ne $NULL){
            Write-host "$TEMP1 Found" 
            }
            ELSE{
            Add-Content $logPath "Critical Error!  Internet Explorer 11 $TEMP1 Not detected."
            Add-Content $logPath "Terminating Script"
            Throw "Cannot find $TEMP1.  Internet Explorer 11 not installed"
            }
        }
        Add-Content $LogPath "Internet Explorer Installation Complete"
        Add-Content $LogPath ""
        Add-Content $logPath "* * * * * * * * * *"
        Add-Content $logPath ""
        
        ##Detect Languages installed and install IE language packs for those languages.
        $OSInfo = Get-WMIObject -Class Win32_OperatingSystem
        $OSLangPacks = $OSInfo.MUILanguages
        $i=0
        $t = $OSLangPacks.Count
        Add-Content $logPath "Installing Language Packs..."
        $OSLangPacks | Foreach-object {
            write-progress -Activity "installing Languages for IE 11" -Status "$i / $t Complete" -percentcomplete($i/$t*100)
            $ITEMNAME = $_
            Add-Content $logPath "  Installing $ITEMNAME"
            $STDOUT = $AppLogs + '\' + $ITEMNAME + '.txt'
            $STDERR = $AppLogs + '\' + $ITEMNAME + '_Errors.txt'
            $DISMARG = ' /Online /add-package /packagepath:".\Languages\'+$3264+'\'+$ITEMNAME+'.cab" /norestart'
            start-process -filepath 'dism.exe' -argumentlist $DISMARG -erroraction stop -nonewwindow -RedirectStandardOutput $STDOUT -RedirectStandardError $STDERR -wait
            $i = $i + 1
            IF ((get-content $STDERR) -eq $NULL)
            {
            Remove-Item $STDERR
            }
            $i = $i + 1
            }
        Add-Content $LogPath "Language Pack installation Complete"
        Add-Content $LogPath ""
        Add-Content $logPath "* * * * * * * * * *"
        Add-Content $logPath ""    
        }
    }
}

ELSE {   
    #Remove IE 11
    Add-Content $LogPath "Removing Internet Explorer 11..."
    $ITEMNAME = "IE-Win7.cab"
    Add-Content $logPath "  Removing $ITEMNAME"
    $STDOUT = $AppLogs + '\' + $ITEMNAME + '.txt'
    $STDERR = $AppLogs + '\' + $ITEMNAME + '_Errors.txt'
    $DISMARG = '/online /remove-package /packagepath:".\IE11\'+$3264+'\IE-Win7.cab" /norestart'
    Start-process -filepath 'dism.exe'-argumentlist $DISMARG -erroraction stop -nonewwindow -RedirectStandardOutput $STDOUT -RedirectStandardError $STDERR -wait  
    Add-Content $LogPath "Internet Explorer Removal Complete"
    Add-Content $LogPath ""
    Add-Content $logPath "* * * * * * * * * *"
    Add-Content $logPath "" 
}

#End Script
$TimeStamp = Get-Date
Add-Content $LogPath "Script Finish: $TimeStamp"
Add-Content $logPath "Script Complete."
