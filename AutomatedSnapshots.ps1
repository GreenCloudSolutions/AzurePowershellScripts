$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}


$disks=Get-AzureRmDisk -ResourceGroupName "MyResourceGroup" | Select Name,Tags,Id,Location,ResourceGroupName ; 
foreach($disk in $disks) 
{ 
    foreach($tag in $disk.Tags) 
    { 
        if($tag.Snapshot -eq 'True') 
        {
            $snapshotconfig = New-AzureRmSnapshotConfig -SourceUri $disk.Id -CreateOption Copy -Location $disk.Location -AccountType Premium_LRS;
            $SnapshotName=$disk.Name+(Get-Date -Format "yyyy-MM-dd");
            $snapshot = New-AzureRmSnapshot -Snapshot $snapshotconfig -SnapshotName $SnapshotName -ResourceGroupName $disk.ResourceGroupName;

          
        }
    }
}

$dte = Get-Date;
$dte = $dte.AddDays(-7);
$snapshots=Get-AzureRmSnapshot -ResourceGroupName "MyResourceGroup" | Where-Object {$_.Timestamp -gt $dte}
foreach($snapshot in $snapshots)
{
      Remove-AzureRmSnapshot -ResourceGroupName "MyResourceGroup" -SnapshotName $snapshot.Name -Force; 
}
