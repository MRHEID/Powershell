


#Parameters
Param (
    [Parameter(mandatory=$True,position=1)]
    [string] $SharePath
)

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

$inventory = Get-ChildItem $SharePath -recurse | Select-Object FullName | foreach-object {
    $FullName = $_.FullName
    $ACL = Get-ACL $FullName
    $ACLTABLE = $ACL.Access | Foreach-object {
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
}

$table | Format-Table -AutoSize

$CSVPath = "$ENV:USERPROFILE\Desktop\NTFS_Report" + "$PATH" +".csv"

$tabCsv = $Table | export-CSV $CSVPath -NoType
