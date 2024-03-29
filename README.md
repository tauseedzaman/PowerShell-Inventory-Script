# PowerShell Inventory Script

This PowerShell script is designed to inventory the size of directories on remote Windows hosts. It retrieves the size of the "Documents" directory for each user on each host listed in the `hostnames.txt` file and exports the data to a CSV file.

## Usage

1. Clone or download this repository to your local machine.
2. Modify the `hostnames.txt` file to include the hostnames or IP addresses of the Windows hosts you want to inventory.
3. Run the script by executing `InventoryDirectories.ps1`.
4. The script will iterate through each host listed in `hostnames.txt`, retrieve the size of the "Documents" directory for each user, and export the data to `output.csv`.

## Requirements

- This script requires PowerShell to be installed on the machine where it is executed.
- The script must be run with administrative privileges on the machine where it is executed.
- Remote PowerShell access must be enabled on the target Windows hosts.

## File Structure

- `InventoryDirectories.ps1`: The main PowerShell script for inventorying directory sizes.
- `hostnames.txt`: A text file containing the hostnames or IP addresses of the Windows hosts to inventory.
- `output.csv`: The CSV file where the inventory data will be exported.

## Notes

- Make sure to review and understand the script before executing it.
- Ensure that appropriate permissions are set for accessing remote hosts and directories.

---