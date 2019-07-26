# AzurePowershellScripts

## AutomatedSnapshots.ps1
This powershell script is based upon https://www.techmanyu.com/automate-disk-snapshots-azure/ and is expected to run with in a Azure Automation Runbook. Therefore the way the loggin in to Azure is done, has been changed. Furthermore removal of snapshots that are older than 7 days is included
