Get-Module -Name AzureAD -ListAvailable
Get-Module -Name AzureADPreview -ListAvailable

Import-Module -Name AzureAD

Connect-AzureAD

$Users = Import-Csv -Path ./Users.csv

foreach ($User in $Users) {

    $Displayname = "$User.GivenName $User.Surname"
    $DomainName = (Get-AzureADDomain).Name
    $UPN = "$User.GivenName" + '@' + "$DomainName"

    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $User.Password
    $PasswordProfile.EnforceChangePasswordPolicy = $true
    $PasswordProfile.ForceChangePasswordNextLogin = $true

    New-AzureADUser `
        -AccountEnabled $true `
        -GivenName $User.GivenName `
        -Surname $Users.Surname `
        -DisplayName $Displayname
        -Department $User.Department `
        -Country $User.Country `
        -UsageLocation $User.UsageLocation `
        -UserPrincipalName $UPN `
        -PasswordProfile $PasswordProfile
}