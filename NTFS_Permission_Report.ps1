############################################
###           NTFS Report v1.1           ###
###     Created by MR.HEID 10222015      ###
############################################


#Parameters
Param (
    [Parameter(mandatory=$True,position=1)]
    [string] $SharePath
)

#Clear Screen
CLS

#Name Script
$ScriptName = "NTFS_Report_v1.0"

#Create Table
$tabName = "AccessReport"

#Create Table object
$table = New-Object system.Data.DataTable “$tabName”

#Define Columns
$path = New-Object system.Data.DataColumn Path,([string])
$FileSystemRights = New-Object system.Data.DataColumn FileSystemRights,([string])
$AccessControlType = New-Object system.Data.DataColumn AccessControlType,([string])
$IdentityReference = New-Object system.Data.DataColumn IdentityReference,([string])
$IsInherited = New-Object system.Data.DataColumn IsInherited,([string])
$InheritanceFlags = New-Object system.Data.DataColumn InheritanceFlags,([string])
$PropagationFlags = New-Object system.Data.DataColumn PropagationFlags,([string])

#Add the Columns
$table.columns.add($path)
$table.columns.add($FileSystemRights)
$table.columns.add($AccessControlType)
$table.columns.add($IdentityReference)
$table.columns.add($IsInherited)
$table.columns.add($InheritanceFlags)
$table.columns.add($PropagationFlags)

#Inspect folder and get all items contained.
$Inventory = @()
$Object = New-Object -TypeName PSObject
$Object | Add-member -MemberType NoteProperty -Name FullName -value ""
Get-ChildItem $SharePath -recurse | Select-Object FullName | foreach-object {
    $FullName = $_.FullName
    #Inspect each item within the folder and get the ACL for each item
    write-host "Identified $FullName"
    $Inventory += $FullName
    }

#Count of the lines in inventory
$NoItems = ($inventory).count
$i = 1

$inventory | Foreach-object {
    $FullName = $_
    Write-Progress -Activity "Working on $FullName" -status "$i out of $NoItems " -PercentComplete($i/$NoItems*100)
    ($ACL = Get-ACL $FullName).Access | Foreach-object {
        #insert row into table for each ACL entry
        $row = $table.NewRow()
        $row.path = $FullName
        $row.FileSystemRights = $_.FileSystemRights
        $row.AccessControlType = $_.AccessControlType
        $row.IdentityReference = $_.IdentityReference
        $row.IsInherited = $_.IsInherited
        $row.InheritanceFlags = $_.InheritanceFlags
        $row.PropagationFlags = $_.PropagationFlags
        $row = $table.Rows.Add($row)
    }
    $i = $i + 1
}


#show the table, formatted as a table
Write-host "Building Table...."
$table | Format-Table -AutoSize

#generate .csv file version of the table, and place on the desktop.
$CSVPath = "$ENV:USERPROFILE\Desktop\NTFS_Report.csv"
$tabCsv = $Table | export-CSV $CSVPath -NoType

#End Script
