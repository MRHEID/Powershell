############################################
###        AD Group Report v1.0          ###
###     Created by MR.HEID 10232015      ###
############################################

#Parameters
PARAM (
    [Parameter(mandatory=$True,position=1)]
    [string] $TextFile
)


#Clear Screen
CLS

#Name Script
$ScriptName = "AD Group Report"

#Create Table
$tableName = "AD_Group_Report"

#Create Table Object
$Table = New-Object System.Data.DataTable "$TableName"

#Define Columns
$AD_Group = New-Object system.Data.DataColumn AD_Group,([string])
$AD_Group_User = New-Object system.Data.DataColumn AD_Group_User,([string])

#Add the Columns
$table.columns.add($AD_Group)
$table.columns.add($AD_Group_User)

#Load Group Names from TXT File
$GroupList = Get-Content $TextFile 

#count of lines in text file
$NoItems = ($GroupList).count
$i = 1

$Grouplist | ForEach-Object {
    $TempGroupName = $_
    Write-Progress -Activity "Working on $TempGroupName" -status "$i out of $NoItems " -PercentComplete($i/$NoItems*100)
    #Edit Group name to remove "[domain]\"
    $pos = $TempGroupName.IndexOf("\")
    $FixedGroupName = $TempGroupName.Substring($pos+1)
    $TempGroupInfo = Get-ADGroupMember $FixedGroupName | ForEach-Object {
        $TempUserID = $_.NAME
        $Row = $Table.NewRow()
        $Row.AD_Group = $TempGroupName
        $Row.AD_Group_User = $TempUserID
        $Row = $Table.Rows.Add($row)
    }
$i = $i + 1
}

#Show the Table, Formatted as a table
write-host "Building Table..."
$Table | Format-Table -AutoSize

#generate .csv file version of the table, and place on the desktop.
$CSVPath = "$ENV:USERPROFILE\Desktop\AD_Group_Report" + "$PATH" +".csv"
$tabCsv = $Table | export-CSV $CSVPath -NoType
