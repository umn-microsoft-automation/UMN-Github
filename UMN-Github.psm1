###
# Copyright 2017 University of Minnesota, Office of Information Technology

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

###########################
#
# Module for interacting with on premise gitHub service.
# Module is designed to work with both public and private(Enterprise) github APIv3 over https ONLY
# https://developer.github.com/enterprise/2.8/v3/
#
###########################


function Get-BasicAuthCredentials {
	<#
		.SYNOPSIS
			Get a string representing basic authentication credentials for use with REST api calls

		.DESCRIPTION
			Takes in a username and a password then returns a base64 string which can be used as a basic credential for REST apis

		.PARAMETER Username
			String for the username

		.PARAMETER Password
			String for the password

		.NOTES
			Name: Get-BasicAuthCredentials
			Author: Jeff Bolduan
			LASTEDIT: 3/11/2016

		.EXAMPLE
			Get-BasicAuthCredentials -Username "Test" -Password "Test"
		
			This will return a string: VGVzdDpUZXN0
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Username,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Password
	)

	$AuthString = "$($Username):$($Password)"
	$AuthBytes = [System.Text.Encoding]::ASCII.GetBytes($AuthString)

	return [System.Convert]::ToBase64String($AuthBytes)
}


function Get-GitHubRepoRefs {
		<#
		.SYNOPSIS
		Get list of Repo Refs

		.DESCRIPTION
		Takes in a username, password,  repository, organization and a file to output to then downloads the file.

		.PARAMETER Username
		Username string to connect to on premise GitHub instance.

		.PARAMETER Password
		Password string to connect to on premise GitHub instance.

		.PARAMETER authToken
		Use instead of user/pass, personal auth token

		.PARAMETER File
		Filename string which needs to be downloaded from the repository.

		.PARAMETER Repo
		Repository name string which is used to identify which repository under the organization to go into.

		.PARAMETER Org
		Organization name string which is used to identify which organization in the GitHub instance to go into.


		.NOTES
		Name: Get-GitHubRepoRefs
		Author: Travis Sobeck
		LASTEDIT: 4/26/2017

		.EXAMPLE
		Get-GitHubRepoRefs -Username "Test" -Password "pass" -Repo "MyFakeReop" -Org "MyFakeOrg" -server "onPremiseServer"

		This command will connect to the UMN GitHub instance and download the psscript1 file from the MyFakeRepo repository
		which is under the MyFakeOrg organization.  It will create the file at C:\Temp called psscript.ps1.
	#>
	[CmdletBinding()]
	param(
		[Parameter(ParameterSetName='BasicAuth',Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Username,

		[Parameter(ParameterSetName='BasicAuth',Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Password,

		[Parameter(ParameterSetName='TokenAuth',Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$authToken,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Repo,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Org,

        ## The Default is public github but you can se this if you are running your own Enterprise Github server
		[string]$server = 'github.com'
	)

	if ($authToken){$Headers = @{"Authorization" = "token $authToken"}}
	else{
		$Credential = Get-BasicAuthCredentials -Username $Username -Password $Password	
		$Headers = @{"Authorization" = "Basic $Credential"}
	}
    if ($server -eq 'github.com'){$conn = "https://api.github.com"}
    else{$conn = "https://$server/api/v3"}
	$URI = "$conn/repos/$org/$Repo/git/refs"
	Invoke-RestMethod -Method Get -Uri $URI -Headers $Headers
}


function Get-GitHubRepoFile {
		<#
		.SYNOPSIS
		Get a file from a GitHub Repo.

		.DESCRIPTION
		Takes in a username, password, filename, repository, organization and a file to output to then downloads the file
		from the repository.

		.PARAMETER Username
		Username string to connect to the UMN GitHub instance.

		.PARAMETER Password
		Password string to connect to the UMN GitHub instance.

		.PARAMETER authToken
		Use instead of user/pass, personal auth token

		.PARAMETER File
		Filename string which needs to be downloaded from the repository.

		.PARAMETER Repo
		Repository name string which is used to identify which repository under the organization to go into.

		.PARAMETER Org
		Organization name string which is used to identify which organization in the GitHub instance to go into.

		.PARAMETER OutFile
		A string representing the local file path to download the GitHub file to.

		.NOTES
		Name: Get-GitHubRepoFile
		Author: Jeff Bolduan
		LASTEDIT:  4/26/2017

		.EXAMPLE
		Get-GitHubRepoFile -Username "Test" -Password "pass" -File "psscript.ps1" -Repo "MyFakeReop" -Org "MyFakeOrg" -OutFile "C:\temp\psscript.ps1" -server "ServerFQDN"

		This command will connect to the UMN GitHub instance and download the psscript1 file from the MyFakeRepo repository
		which is under the MyFakeOrg organization.  It will create the file at C:\Temp called psscript.ps1.
	#>
	[CmdletBinding()]
	param(
		[Parameter(ParameterSetName='BasicAuth',Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Username,

		[Parameter(ParameterSetName='BasicAuth',Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Password,

		[Parameter(ParameterSetName='TokenAuth',Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$authToken,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$File,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Repo,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Org,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$OutFile,

		## The Default is public github but you can se this if you are running your own Enterprise Github server
		[string]$server = 'github.com'
	)

	if ($authToken){$Headers = @{"Authorization" = "token $authToken"}}
	else{
		$Credential = Get-BasicAuthCredentials -Username $Username -Password $Password	
		$Headers = @{"Authorization" = "Basic $Credential"}
	}
	if ($server -eq 'github.com'){$conn = "https://api.github.com"}
    else{$conn = "https://$server/api/v3"}
	$URI = "$conn/repos/$org/$Repo/contents/$File"
	$RESTRequest = Invoke-RestMethod -Method Get -Uri $URI -Headers $Headers
	if($RESTRequest.download_url -eq $null) {
		throw [System.IO.IOException]
	} else {
		$WebRequest = Invoke-WebRequest -Uri $RESTRequest.download_url -Headers $Headers -OutFile $OutFile
	}
}


function Get-GitHubRepoUnZipped {
<#
	.SYNOPSIS
	Get a GitHub Repo.

	.DESCRIPTION
	Takes in a username, password, repository, organization and a folder to output to then downloads the files
	from the repository.

	.PARAMETER Username
	Username string to connect to the UMN GitHub instance.

	.PARAMETER Password
	Password string to connect to the UMN GitHub instance.

	.PARAMETER authToken
	Use instead of user/pass, personal auth token

	.PARAMETER Repo
	Repository name string which is used to identify which repository under the organization to go into.

	.PARAMETER Org
	Organization name string which is used to identify which organization in the GitHub instance to go into.

	.PARAMETER OutFolder
	A string representing the local file path to download the GitHub Reop file to.


	.EXAMPLE
	Get-GitHubRepoUnZipped -authToken $authToken -Repo $repo -Org $org -OutFolder $pathToFolder.
#>

	[CmdletBinding()]
	param(
		[Parameter(ParameterSetName='BasicAuth',Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Username,

		[Parameter(ParameterSetName='BasicAuth',Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Password,

		[Parameter(ParameterSetName='TokenAuth',Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$authToken,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Org,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$repo,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$outFolder,

        [Parameter(Mandatory=$true)]
		[string]$ref = "master",

		## The Default is public github but you can se this if you are running your own Enterprise Github server
		[string]$server = 'github.com'
	)

	# validate folder exits #
    if (-not(Test-Path $outFolder)){$null = New-Item $outFolder -ItemType Directory -Force}
    # get zip
    if ($authToken){Get-GitHubRepoZip -authToken $authToken -Org $org -repo $repo -OutFile "$outFolder\$repo.zip" -ref $ref -server $server}
	else{Get-GitHubRepoZip -Username $Username -Password $Password -Org $org -repo $repo -OutFile "$outFolder\$repo.zip" -server $server}
    # unzip
    Expand-Archive -Path "$outFolder\$repo.zip" -DestinationPath $outFolder -Force
    # get the actual folder name, yeah this looks funky but OpenRead locks the file, this is need to get the folder name and still remove the zip file later
    $scriptblock = {Param( [string]$path)
        $null = [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')
        $folder = [IO.Compression.ZipFile]::OpenRead((Get-Item -Path $path).FullName).Entries[0].FullName
        $folder = $folder.TrimEnd('/') # trip the stupid trailing slash
        $folder
    }
    $job = Start-Job -Name 'temp' -ArgumentList "$outFolder\$repo.zip" -ScriptBlock $scriptblock
    do{Start-Sleep -Seconds 1}until((Get-Job -Id $job.Id).State -eq 'Completed')
    $folder = Receive-Job -Job $job
    
    # rename the folder the the repo
    Rename-Item -Path "$outFolder\$folder" -NewName "$repo"-Force
    Remove-Item -Path "$outFolder\$repo.zip" -Force
}


function Get-GitHubRepoZip {
	# https://developer.github.com/v3/repos/contents/#get-archive-link

<#
	.SYNOPSIS
	Get a GitHub Repo.

	.DESCRIPTION
	Takes in a username, password, repository, organization and a file to output to then downloads the file
	from the repository.

	.PARAMETER Username
	Username string to connect to the UMN GitHub instance.

	.PARAMETER Password
	Password string to connect to the UMN GitHub instance.

	.PARAMETER authToken
	Use instead of user/pass, personal auth token

	.PARAMETER Repo
	Repository name string which is used to identify which repository under the organization to go into.

	.PARAMETER Org
	Organization name string which is used to identify which organization in the GitHub instance to go into.

	.PARAMETER OutFile
	A string representing the local file path to download the GitHub Zip file to.


	.EXAMPLE
	Get-GitHubRepoZip -authToken $authToken -Repo $repo -Org $org -OutFile $outFile -server "ServerFQDN"

	This command will connect to the UMN GitHub instance and download the psscript1 file from the MyFakeRepo repository
	which is under the MyFakeOrg organization.  It will create the file at C:\Temp called psscript.ps1.
#>
    [CmdletBinding()]
	param(
		[Parameter(ParameterSetName='BasicAuth',Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Username,

		[Parameter(ParameterSetName='BasicAuth',Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Password,

		[Parameter(ParameterSetName='TokenAuth',Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$authToken,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Org,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$repo,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$OutFile,

        [Parameter(Mandatory=$true)]
		[string]$ref = "master",

		## The Default is public github but you can se this if you are running your own Enterprise Github server
		[string]$server = 'github.com'
	)

	if ($authToken){$Headers = @{"Authorization" = "token $authToken"}}
	else{
		$Credential = Get-BasicAuthCredentials -Username $Username -Password $Password	
		$Headers = @{"Authorization" = "Basic $Credential"}
	}
    
    if ($server -eq 'github.com'){$conn = "https://api.github.com"}
    else{$conn = "https://$server/api/v3"}
	$URI = "$conn/repos/$Org/$repo/zipball/$ref"

    Invoke-RestMethod -Method Get -Uri $URI -Headers $Headers -OutFile $OutFile
}

