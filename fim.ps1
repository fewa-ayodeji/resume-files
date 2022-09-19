# Add module or class
Add-Type -AssemblyName System.Windows.Forms

#Function to get folder containing files to baseline
Function get-FilesInFolder(){
    $browser = New-Object System.Windows.Forms.FolderBrowserDialog
    $browser.Description = "Select folder containing files to baseline/monitor"
    $null = $browser.ShowDialog()
    $global:path = $browser.SelectedPath
    return $path
}

# Function to select folder where baseline text will be stored
Function baselineFolder(){
    $browser = New-Object System.Windows.Forms.FolderBrowserDialog
    $browser.Description = "Select folder to store baseline text"
    $null = $browser.ShowDialog()
    $global:baselinepath = $browser.SelectedPath
    
    return $baselinepath
}

# Function to select file containing baselined information
Function baselineText(){
    $browser = New-Object System.Windows.Forms.OpenFileDialog
    $browser.Title = "Select baseline text"
    $null = $browser.ShowDialog()
    $global:baselinetext = $browser.FileName
    
    return $baselinetext
}

# Function to calculate hash
Function Calculate-File-Hash($filepath){
   $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
   return $filehash
}

# Function to erase baseline file if it already exists
Function Erase-Baseline-If-Already-Exists($baselinepath){
    $test = Test-Path -Path $baselinepath\baseline.txt
    if ($test) {
       Remove-Item -Path $baselinepath\baseline.txt 
    }
}


# Get information from user on what they want to do

write-host "`nWhat will you like to do?`n"
write-host "A) Collect new Baseline"
write-host "B) Begin monitoring files with saved baseline"

$response = Read-Host -Prompt "Please enter 'A' or 'B'`n"


# Act based on option selected

# Option A
# Create new baseline

if ($response -eq "A".ToUpper()) {
    # calcualte Hash from the target files and store in baseline.txt
    
    # Collect all files in the target folder
    get-FilesInFolder
    $files = Get-ChildItem -Path $path

    # Select baseline path and Delete baseline.txt if it already exists
    baselineFolder
    Erase-Baseline-If-Already-Exists $baselinepath
       
    # For each file calculate the hash, and write to baseline.txt
    foreach ($f in $files){
        $hash = Calculate-File-Hash $f.Fullname
        "$($hash.Path)|$($hash.Hash)" | Out-file -FilePath $baselinepath\baseline.txt -Append
    }
}


# Option B

# Select baseline file
# Monitor files in a selected folder

elseif ($response -eq "B".ToUpper()){

    $fileHashDictionary = @{}  
     
    # Load file|hash from baseline.txt and store them in a dictionary

    # Get content of baselined text
    baselinetext
    $filePathsAndHashses = Get-Content -Path $baselinetext

    #Get files to monitor
    get-FilesInFolder

    # Store file paths and hashes in a dictionary
    foreach ($f in $filePathsAndHashses){
        $fileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1])
    }


    # Let user know monitoring is in progress
    write-Host "Checking if files match.."

    # Begin continuously monitioring files with saved Baseline

    while($true) {
        # Wait for a second before running
        start-Sleep -Seconds 1
    
        # Get files, calculate hash of files then compare

        # Get files
        $files = Get-ChildItem -Path $path      
        
        # Calculate file hashes
        foreach ($f in $files){
            $hash = Calculate-File-Hash $f.Fullname
            
            # Notify if a new file has been created
            if ($fileHashDictionary[$hash.Path] -eq $null) {
                # A new file has been created! Notify the user
                write-host "$($hash.Path) has been created" -ForegroundColor Green
            }

            # Notify if a file has changed or not
            else {

                if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
                    # The file has not changed
                    write-host "$($hash.Path) has not changed" -ForegroundColor Yellow
                }
                else {
                    # File has been compromised, Notify the user
                    write-Host "$($hash.Path) has changed!!!" -ForegroundColor Red
                }
            }
        }
        
        # Notify if file has been deleted
        foreach ($key in $fileHashDictionary.Keys) {
            $baselineFileStillExists = Test-Path -Path $key
            if (-Not $baselineFileStillExists){
                # one of the baseline files must have been deleted, notify the user
                write-host "$($key) has been deleted!" -ForegroundColor Magenta
            }
        }
    }

}
