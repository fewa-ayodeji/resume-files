# ----- Get list of users from text file in path and create initial password ----- #
$USER_FIRST_LAST_LIST = Get-Content .\Names.txt
$GENERIC_PASSWORD = "Password1" # create Policy to force change after login

# Store generic password in a secure format
# Create new organizational unit, make it easy to delete for future purposes
$password = ConvertTo-SecureString $GENERIC_PASSWORD -AsPlainText -Force
New-ADOrganizationalUnit -Name _USERS -ProtectedFromAccidentalDeletion $false

# Create user in organizational Unit with generic password
foreach ($n in $USER_FIRST_LAST_LIST) {

    # Get first and last name then assign to variables
    $first = $n.Split(" ")[0].ToLower()
    $last = $n.Split(" ")[1].ToLower()

    # Create Username and display name
    # Get first element of first name, combine with last name
    $username = "$($first.Substring(0,1))$($last)".ToLower()
    Write-Host "Creating user: $($username)" -BackgroundColor Black -ForegroundColor Cyan
    
    # Create user in O.U _USERS with the following attributes
    New-AdUser -AccountPassword $password `
        -GivenName $first `
        -Surname $last `
        -DisplayName $username `
        -Name $username `
        -EmployeeID $username `
        -PasswordNeverExpires $true `
        -ChangePasswordAtLogon $true `
        -Path "ou=_USERS,$(([ADSI]`"").distinguishedName)" `
        -Enabled $true
}