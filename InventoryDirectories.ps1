# Define the path to the file containing hostnames
$HostnamesFile = "./hostnames.txt"
# Define the path to the output CSV file
$OutputFile = "./output.csv"

# Function to inventory directory size
Function InventoryDirectory {
    param (
        [parameter(Mandatory = $true)][string]$Hostname,         # Hostname of the remote machine
        [parameter(Mandatory = $true)][string]$Username,         # Username of the user whose directory is being inventoried
        [parameter(Mandatory = $true)][string]$DirectoryToInventory  # Directory path to be inventoried
    )

    # Check if directory exists
    If (Test-Path "$DirectoryToInventory") {
        # Get the total size of files in the directory
        $DirectorySize = (Get-ChildItem "$DirectoryToInventory" -Recurse -File | Measure-Object -Property length -Sum).Sum
        # Convert size to MB and round to 2 decimal places
        if ($DirectorySize) {
            $DirectorySizeMB = ($DirectorySize / 1MB)
            $DirectorySizeMB = [math]::Round($DirectorySizeMB, 2)
        }
        else {
            $DirectorySizeMB = "0"
        }
        # Output the data to the CSV file
        [PSCustomObject]@{
            Hostname = $Hostname
            User     = $Username
            Size_MB  = $DirectorySizeMB
        } | Export-Csv -Path $OutputFile -Append -NoTypeInformation
    }
    else {
        Write-Output "Directory not found: $DirectoryToInventory"
    }
}

# Read hostnames from a text file
$Hostnames = Get-Content $HostnamesFile

# Loop through each hostname in the file
foreach ($hostname in $Hostnames) {
    # Access each host
    $HostUsersDirectory = "\\$hostname\c$\Users"
    Write-Output "Processing host: $hostname"

    # Get all user directories
    $UserDirectories = Get-ChildItem $HostUsersDirectory -Directory | Select-Object -ExpandProperty Name

    # Loop through each user directory
    foreach ($UserDir in $UserDirectories) {
        $DocumentsDirectory = "\\$hostname\c$\Users\$UserDir\Documents"
        Write-Output "Processing directory: $DocumentsDirectory"
        
        # Check if the Documents directory exists
        if (Test-Path $DocumentsDirectory -PathType Container) {
            # Call InventoryDirectory function to inventory the documents directory
            InventoryDirectory -Hostname $hostname -Username $UserDir -DirectoryToInventory $DocumentsDirectory
            Write-Output ""
        }
        else {
            Write-Output "Documents directory not found for user $UserDir on host $hostname"
        }
    }
}
