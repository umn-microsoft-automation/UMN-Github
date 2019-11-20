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

#region New-GitHubHeader
function New-GitHubHeader {
	<#
		.SYNOPSIS
		    Create Header to be consumed by all other functions

		.DESCRIPTION
		    Create Header to be consumed by all other functions

		.PARAMETER psCreds
		    PScredential composed of your username/password to Git Server

		.PARAMETER authToken
		    Use instead of user/pass, personal auth token

		.NOTES
		    Author: Travis Sobeck
		    LASTEDIT: 6/20/2017

		.EXAMPLE

	#>
	[CmdletBinding()]
	param(
		
        [Parameter(Mandatory,ParameterSetName='creds')]
        [System.Management.Automation.PSCredential]$psCreds,

        [Parameter(Mandatory,ParameterSetName='token')]
		[string]$authToken
	)

	if ($authToken){return (@{"Authorization" = "token $authToken"})}
	else{
		$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($psCreds.UserName+':'+$psCreds.GetNetworkCredential().Password))	
		return (@{"Authorization" = "Basic $auth"})
	}
}
#endregion

#region Get-GitHubBase
function Get-GitHubBase {
	<#
		.SYNOPSIS
		    Base for constructing Get commands

		.DESCRIPTION
		    Base for constructing Get commands

		.PARAMETER headers
            Get this from New-GitHubHeader

		.PARAMETER sha
		    sha for the commit, use Get-GitHubRepoRef to get it

		.PARAMETER Repo
		    Repository name string which is used to identify which repository under the organization to go into.

		.PARAMETER Org
		    Organization name string which is used to identify which organization in the GitHub instance to go into.


		.NOTES
		    Author: Travis Sobeck
		    LASTEDIT: 6/20/2017

		.EXAMPLE
		    Get-GitHubCommit -Username "Test" -Password "pass" -Repo "MyFakeReop" -Org "MyFakeOrg" -server "onPremiseServer" -sha $sha

	#>
	[CmdletBinding()]
	param(
		
        [System.Collections.Hashtable]$headers,

		[Parameter(Mandatory)]
		[string]$Repo,

		[Parameter(Mandatory)]
		[string]$Org,

		[Parameter(Mandatory)]
        [string]$data,

        ## The Default is public github but you can se this if you are running your own Enterprise Github server
		[string]$server = 'github.com'
	)

    if ($server -eq 'github.com'){$conn = "https://api.github.com"}
    else{$conn = "https://$server/api/v3"}
	$URI = "$conn/repos/$org/$Repo/git/$data"
	try{return(Invoke-RestMethod -Method Get -Uri $URI -Headers $Headers)}
    catch{throw $Error[0]}
}
#endregion

#region Get-GitHubCommit
function Get-GitHubCommit {
	<#
		.SYNOPSIS
		    Get a specific commit for a specific repo

		.DESCRIPTION
		    Get a specific commit for a specific repo

		.PARAMETER headers
            Get this from New-GitHubHeader

		.PARAMETER sha
		    sha for the commit, use Get-GitHubRepoRef to get it

		.PARAMETER Repo
		    Repository name string which is used to identify which repository under the organization to go into.

		.PARAMETER Org
		    Organization name string which is used to identify which organization in the GitHub instance to go into.


		.NOTES
		    Name: Get-GitHubCommit
		    Author: Travis Sobeck
		    LASTEDIT: 6/20/2017

		.EXAMPLE
		    Get-GitHubCommit -Username "Test" -Password "pass" -Repo "MyFakeReop" -Org "MyFakeOrg" -server "onPremiseServer" -sha $sha

	#>
	[CmdletBinding()]
	param(
		
        [System.Collections.Hashtable]$headers,

		[Parameter(Mandatory)]
		[string]$Repo,

		[Parameter(Mandatory)]
		[string]$Org,

		[Parameter(Mandatory)]
        [string]$sha,

        ## The Default is public github but you can se this if you are running your own Enterprise Github server
		[string]$server = 'github.com'
	)
	Get-GitHubBase -headers $headers -Repo $Repo -Org $Org -server $server -data "commits/$sha"
}
#endregion

#region Get-GitHubRepoRef
function Get-GitHubRepoRef {
	<#
		.SYNOPSIS
		    Get a specific reference or all references for a specific repo

		.DESCRIPTION
		    Get a specific reference or all references for a specific repo, use -ref for a specific reference

		.PARAMETER headers
            Get this from New-GitHubHeader

		.PARAMETER ref
		    Specific ref, run the command without it to get a list example would be.

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

        .EXAMPLE
		    Get-GitHubRepoRefs -Username "Test" -Password "pass" -Repo "MyFakeReop" -Org "MyFakeOrg" -server "onPremiseServer" -ref 'refs/heads/master'

	#>
	[CmdletBinding()]
    [Alias("Get-GitHubRepoRefs")]
	param(
		
        [System.Collections.Hashtable]$headers,

		[Parameter(Mandatory)]
		[string]$Repo,

		[Parameter(Mandatory)]
		[string]$Org,

		[string]$ref,

        ## The Default is public github but you can se this if you are running your own Enterprise Github server
		[string]$server = 'github.com'
	)

    if (-not($ref)){$ref = 'refs'}
	Get-GitHubBase -headers $headers -Repo $Repo -Org $Org -server $server -data $ref
}
#endregion

#region Get-GitHubRepoFile
function Get-GitHubRepoFile {
	<#
		.SYNOPSIS
		    Get a file from a GitHub Repo.

		.DESCRIPTION
		    Takes in a username, password, filename, repository, organization and a file to output to then downloads the file
		    from the repository.

		.PARAMETER headers
            Get this from New-GitHubHeader

		.PARAMETER File
		    Filename string which needs to be downloaded from the repository.

		.PARAMETER Repo
			Repository name string which is used to identify which repository under the organization to go into.
		
		.PARAMETER Branch
		    Branch name string which is used to identify which branch under the repository to go into. Default is master.

		.PARAMETER Org
		    Organization name string which is used to identify which organization in the GitHub instance to go into.

		.PARAMETER OutFile
			A string representing the local file path to download the GitHub file to.

		.NOTES
		    Name: Get-GitHubRepoFile
		    Author: Jeff Bolduan
		    LASTEDIT:  11/20/2019

		.EXAMPLE
		    Get-GitHubRepoFile -Username "Test" -Password "pass" -File "psscript.ps1" -Repo "MyFakeReop" -Org "MyFakeOrg" -OutFile "C:\temp\psscript.ps1" -server "ServerFQDN"

	#>
	[CmdletBinding()]
	param(
		
        [System.Collections.Hashtable]$headers,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$File,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Repo,

        [Parameter(Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[string]$Branch,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Org,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$OutFile,

		## The Default is public github but you can se this if you are running your own Enterprise Github server
		[string]$server = 'github.com'
	)

	if ($server -eq 'github.com'){$conn = "https://api.github.com"}
	else{$conn = "https://$server/api/v3"}
	if($Branch){$URI = "$conn/repos/$org/$Repo/contents/$File" + "?ref=$Branch"}
	else{$URI = "$conn/repos/$org/$Repo/contents/$File"}
    $RESTRequest = Invoke-RestMethod -Method Get -Uri $URI -Headers $Headers
    if($RESTRequest.download_url -eq $null) {
        throw [System.IO.IOException]
    } 
    else {
        $WebRequest = Invoke-WebRequest -Uri $RESTRequest.download_url -Headers $Headers -OutFile $OutFile
    }
}
#endregion

#region Get-GitHubRepoFileContent
function Get-GitHubRepoFileContent {
    <#
		.SYNOPSIS
		    Gets and then returns the contents of a GitHub repo file.

		.DESCRIPTION
			Takes in a username, password, filename, repository, organization and then returns the contents
			of a file from the GitHub repository.

		.PARAMETER headers
            Get this from New-GitHubHeader

		.PARAMETER File
			Filename string which needs to be downloaded from the repository.  This should be the path to the file if it's not
			in the root of the repository for example "fizz/buzz.txt" and keep in mind it should be the forward slashes.

		.PARAMETER Repo
		    Repository name string which is used to identify which repository under the organization to go into.
        .PARAMETER Branch
		    Branch name string which is used to identify which branch under the repository to go into. Default is master.

		.PARAMETER Org
		    Organization name string which is used to identify which organization in the GitHub instance to go into.
		
		.PARAMETER Server
			An optional parameter for the fully qualified domain name of a github server, defaults to github.com but can be an internal
			enterprise server.

		.NOTES
		    Name: Get-GitHubRepoFile
		    Author: Jeff Bolduan
		    LASTEDIT:  11/20/2019

		.EXAMPLE
			$GitHubHeaders = New-GitHubHeader -psCreds (Get-Credential)
			
		    Get-GitHubRepoFile -headers $GitHubHeaders -File "psscript.ps1" -Repo "MyFakeReop" -Org "MyFakeOrg" -server "github.foo.bar"

	#>
    [CmdletBinding()]
    [Alias("Get-GitHubRepoContent")]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Collections.Hashtable]$headers,
		
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$File,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Repo,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Branch,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Org,

        ## The Default is public github but you can set this if you are running your own Enterprise Github server\
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$server = 'github.com'
    )
	
    if ($server -eq 'github.com') { $Connection = "https://api.github.com" }
    else { $Connection = "https://$server/api/v3" }

    Write-Verbose -Message "[VariableValue:Connection] :: $Connection"

    if($Branch){
        $URI = "$Connection/repos/$org/$Repo/contents/$File" + "?ref=$Branch"
    }
    else {
       $URI = "$Connection/repos/$org/$Repo/contents/$File" 
    }
	
	
    Write-Verbose -Message "[VariableValue:URI] :: $URI"
	
    $RESTRequest = Invoke-RestMethod -Method Get -Uri $URI -Headers $Headers
	
    Write-Verbose -Message "[VariableValue:RESTRequest] :: $RESTRequest"

    return([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($RESTRequest.content)))
}
#endregion

#region Get-GitHubTree
function Get-GitHubTree {
	<#
		.SYNOPSIS
		    Get a specific reference or all references for a specific repo

		.DESCRIPTION
		    Get a specific reference or all references for a specific repo, use -ref for a specific reference

		.PARAMETER headers
            Get this from New-GitHubHeader

		.PARAMETER Repo
		    Repository name string which is used to identify which repository under the organization to go into.

		.PARAMETER Org
		    Organization name string which is used to identify which organization in the GitHub instance to go into.

        .PARAMETER sha
            Sha of tree, use (Get-GitHubCommit -authToken $ghAuthToken -Repo $Repo -Org $Org -server $server -sha $sha).tree.sha to get the sha you need

		.NOTES
		    Name: Get-GitHubRepoRefs
		    Author: Travis Sobeck
		    LASTEDIT: 4/26/2017

		.EXAMPLE
		    

        .EXAMPLE
		    

	#>
	[CmdletBinding()]
	param(
		
        [System.Collections.Hashtable]$headers,

		[Parameter(Mandatory)]
		[string]$Repo,

		[Parameter(Mandatory)]
		[string]$Org,

        [Parameter(Mandatory)]
        [string]$sha,

        [switch]$recurse,

        ## The Default is public github but you can se this if you are running your own Enterprise Github server
		[string]$server = 'github.com'
	)

	$data = "trees/$sha"
    if ($recurse){$data += "?recursive=1"}
	Get-GitHubBase -headers $headers -Repo $Repo -Org $Org -server $server -data $data
}
#endregion

#region Get-GitHubRepoUnZipped
function Get-GitHubRepoUnZipped {
	<#
		.SYNOPSIS
			Get a GitHub Repo.

		.DESCRIPTION
			Takes in a username, password, repository, organization and a folder to output to then downloads the files
			from the repository.

		.PARAMETER headers
				Get this from New-GitHubHeader

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
		
        [System.Collections.Hashtable]$headers,

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
    Get-GitHubRepoZip -Org $org -repo $repo -OutFile "$outFolder\$repo.zip" -ref $ref -server $server -headers $headers
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
#endregion

#region Get-GitHubRepoZip
function Get-GitHubRepoZip {
	<#
		.SYNOPSIS
			Get a GitHub Repo and download to zip file.

		.DESCRIPTION
			Takes in a PSCredention or Auth Key if needed, repository, organization and a file to output to then downloads the file
			from the repository.

		.PARAMETER headers
				Get this from New-GitHubHeader

		.PARAMETER Repo
			Repository name string which is used to identify which repository under the organization to go into.

		.PARAMETER Org
			Organization name string which is used to identify which organization in the GitHub instance to go into.

		.PARAMETER OutFile
			A string representing the local file path to download the GitHub Zip file to.


		.EXAMPLE
			Get-GitHubRepoZip -authToken $authToken -Repo $repo -Org $org -OutFile $outFile -server "ServerFQDN"

	#>
    [CmdletBinding()]
	param(

        [System.Collections.Hashtable]$headers,

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

	if ($server -eq 'github.com'){$conn = "https://api.github.com"}
    else{$conn = "https://$server/api/v3"}
	$URI = "$conn/repos/$Org/$repo/zipball/$ref"

    Invoke-RestMethod -Method Get -Uri $URI -Headers $Headers -OutFile $OutFile
}
#endregion

#region New-GitHubBlob
function New-GitHubBlob {
	<#
		.SYNOPSIS
		    Create a new Blob

		.DESCRIPTION
		    Create a new Blob

		.PARAMETER headers
            Get this from New-GitHubHeader

		.PARAMETER Repo
		    Repository name string which is used to identify which repository under the organization to go into.

		.PARAMETER Org
		    Organization name string which is used to identify which organization in the GitHub instance to go into.

        .PARAMETER filePath
            Path to file to be added/modified

		.NOTES
		    Author: Travis Sobeck
		    LASTEDIT: 6/20/2017

		.EXAMPLE
		   
	#>
	[CmdletBinding()]
	param(
		
        [Parameter(Mandatory)]
        [System.Collections.Hashtable]$headers,

		[Parameter(Mandatory)]
		[string]$Repo,

		[Parameter(Mandatory)]
		[string]$Org,

        [Parameter(Mandatory)]
        [string]$filePath,

        ## The Default is public github but you can se this if you are running your own Enterprise Github server
		[string]$server = 'github.com'
	)

	if ($server -eq 'github.com'){$conn = "https://api.github.com"}
    else{$conn = "https://$server/api/v3"}
	$URI = "$conn/repos/$org/$Repo/git/blobs"
    $content = $base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((Get-Content -Path $filePath -Raw)))
    $json = @{"content" = $content;"encoding" = "base64"} | ConvertTo-Json -Depth 3
	Invoke-RestMethod -Method Post -Uri $URI -Headers $Headers -Body $json
}
#endregion

#region New-GitHubCommit
function New-GitHubCommit {
	<#
		.SYNOPSIS
		    Create a new commit for a specific repo

		.DESCRIPTION
		    Create a new commit for a specific repo

		.PARAMETER headers
            Get this from New-GitHubHeader

		.PARAMETER Repo
		    Repository name string which is used to identify which repository under the organization to go into.

		.PARAMETER Org
		    Organization name string which is used to identify which organization in the GitHub instance to go into.

        .PARAMETER message
            The commit message
        
        .PARAMETER tree
            The SHA of the tree object this commit points to
            
        .PARAMETER parents
            The SHAs of the commits that were the parents of this commit. If omitted or empty, the commit will be written as a root commit. For a single parent, an array of one SHA should be provided; for a merge commit, an array of more than one should be provided.

		.NOTES
		    Author: Travis Sobeck
		    LASTEDIT: 6/20/2017

		.EXAMPLE
		    

	#>
	[CmdletBinding()]
	param(
		
        [Parameter(Mandatory)]
        [System.Collections.Hashtable]$headers,

		[Parameter(Mandatory)]
		[string]$Repo,

		[Parameter(Mandatory)]
		[string]$Org,

		[Parameter(Mandatory)]
        [string]$message,

        [Parameter(Mandatory)]
        [string]$tree,

        [Parameter(Mandatory)]
        [array]$parents,

        ## The Default is public github but you can se this if you are running your own Enterprise Github server
		[string]$server = 'github.com'
	)

	if ($server -eq 'github.com'){$conn = "https://api.github.com"}
    else{$conn = "https://$server/api/v3"}
	$URI = "$conn/repos/$org/$Repo/git/commits"
    $content = Get-Content $filePath
    $json = @{"message" = $message; "parents" = $parents; "tree" = $tree} | ConvertTo-Json -Depth 3
	Invoke-RestMethod -Method Post -Uri $URI -Headers $Headers -Body $json
}
#endregion

#region New-GitHubTree
function New-GitHubTree {
	<#
		.SYNOPSIS
		    Get a specific commit for a specific repo

		.DESCRIPTION
		    Get a specific commit for a specific repo,

		.PARAMETER headers
            Get this from New-GitHubHeader

		.PARAMETER Repo
		    Repository name string which is used to identify which repository under the organization to go into.

		.PARAMETER Org
		    Organization name string which is used to identify which organization in the GitHub instance to go into.

        .PARAMETER path
            path to file in github
        
        .PARAMETER baseTree
            This is the SHA for the tree this is getting added onto, use Get-GitHubCommit and store  ie $treeSha = $commit.tree.sha
            
        .PARAMETER mode
            The file mode; one of 100644 for file (blob), 100755 for executable (blob), 040000 for subdirectory (tree), 160000 for submodule (commit), or 120000 for a blob that specifies the path of a symlink

        .PARAMETER type
            Either blob, tree, or commit

        .PARAMETER blobSha
            Sha from the blob containing the content, use New-GitHubBlob and record the return sha

		.NOTES
		    Author: Travis Sobeck
		    LASTEDIT: 6/20/2017

		.EXAMPLE

	#>
	[CmdletBinding()]
	param(
		
        [Parameter(Mandatory)]
        [System.Collections.Hashtable]$headers,

		[Parameter(Mandatory)]
		[string]$Repo,

		[Parameter(Mandatory)]
		[string]$Org,

		[Parameter(Mandatory)]
        [string]$baseTree,

        [Parameter(Mandatory)]
        [string]$path,

        [Parameter(Mandatory)]
        [string]$mode,

        [Parameter(Mandatory)]
        [string]$type,

        [Parameter(Mandatory)]
        [string]$blobSha,

        ## The Default is public github but you can se this if you are running your own Enterprise Github server
		[string]$server = 'github.com'
	)

	if ($server -eq 'github.com'){$conn = "https://api.github.com"}
    else{$conn = "https://$server/api/v3"}
	$URI = "$conn/repos/$org/$Repo/git/trees"
    $json = @{"base_tree" = $baseTree;"tree" = @(@{"path" = $path;"mode"=$mode;"type" = $type;"sha" = $blobSha})} | ConvertTo-Json -Depth 3
	Invoke-RestMethod -Method Post -Uri $URI -Headers $Headers -Body $json
}
#endregion

#region Set-GitHubCommit
function Set-GitHubCommit {
	<#
		.SYNOPSIS
		    Update a reference to a new Commit

		.DESCRIPTION
		    Update a reference to a new Commit

		.PARAMETER headers
            Get this from New-GitHubHeader

		.PARAMETER Repo
		    Repository name string which is used to identify which repository under the organization to go into.

		.PARAMETER Org
		    Organization name string which is used to identify which organization in the GitHub instance to go into.

        .PARAMETER ref
            ref to be updated
        
        .PARAMETER sha
            SHA to update reference to, get this from New-GitHubCommit
            
        .PARAMETER parents
            The SHAs of the commits that were the parents of this commit. If omitted or empty, the commit will be written as a root commit. For a single parent, an array of one SHA should be provided; for a merge commit, an array of more than one should be provided.

		.NOTES
		    Author: Travis Sobeck
		    LASTEDIT: 6/20/2017

		.EXAMPLE
		    

	#>
	[CmdletBinding()]
	param(
		
        [Parameter(Mandatory)]
        [System.Collections.Hashtable]$headers,

		[Parameter(Mandatory)]
		[string]$Repo,

		[Parameter(Mandatory)]
		[string]$Org,

		[Parameter(Mandatory)]
        [string]$ref,

        [Parameter(Mandatory)]
        [string]$sha,

        ## The Default is public github but you can se this if you are running your own Enterprise Github server
		[string]$server = 'github.com'
	)

	if ($server -eq 'github.com'){$conn = "https://api.github.com"}
    else{$conn = "https://$server/api/v3"}
	$URI = "$conn/repos/$org/$Repo/git/$ref"
    $json = @{"sha" = $sha;"force"=$true} | ConvertTo-Json -Depth 3
	Invoke-RestMethod -Method Patch -Uri $URI -Headers $Headers -Body $json
}
#endregion

#region Update-GitHubRepo
function Update-GitHubRepo {
	<#
		.SYNOPSIS
		    Get a specific reference or all references for a specific repo

		.DESCRIPTION
		    Get a specific reference or all references for a specific repo, use -ref for a specific reference

		.PARAMETER headers
            Get this from New-GitHubHeader

		.PARAMETER ref
		    Specific ref, run the command without it to get a list example would be.

		.PARAMETER Repo
		    Repository name string which is used to identify which repository under the organization to go into.

		.PARAMETER Org
		    Organization name string which is used to identify which organization in the GitHub instance to go into.

        .PARAMETER message
            The commit message

        .PARAMETER path
            path to file in github

        .PARAMETER filePath
            Path to file to be added/modified

		.NOTES
		    Author: Travis Sobeck
		    LASTEDIT: 4/26/2017

		.EXAMPLE
		    

	#>
	[CmdletBinding()]
	param(
		
        [Parameter(Mandatory)]
        [System.Collections.Hashtable]$headers,

		[Parameter(Mandatory)]
		[string]$Repo,

		[Parameter(Mandatory)]
		[string]$Org,

        [Parameter(Mandatory)]		
        [string]$ref,

        [Parameter(Mandatory)]
        [string]$message,

        [Parameter(Mandatory)]
        [string]$path,

        [Parameter(Mandatory)]
        [string]$filePath,

        ## The Default is public github but you can se this if you are running your own Enterprise Github server
		[string]$server = 'github.com'
	)

    try{
        # Get reference to head of ref provided and record Sha
        $reference = Get-GitHubRepoRef -headers $headers -Repo $Repo -Org $Org -server $server -ref $ref
        $sha = $reference.object.sha
        # get commit for that ref and store Sha
        $commit = Get-GitHubCommit -headers $headers -Repo $Repo -Org $Org -server $server -sha $sha
        $treeSha = $commit.tree.sha
        # Creat Blob
        $blob = New-GitHubBlob -headers $headers -Repo $Repo -Org $Org -server $server -filePath $filePath
        # create new Tree
        $tree = New-GitHubTree -headers $headers -Repo $Repo -Org $Org -server $server -path $path -blobSha $blob.sha -baseTree $treeSha -mode 100644 -type 'blob'
        # create new commit
        $newCommit = New-GitHubCommit -headers $headers -Repo $Repo -Org $Org -server $server -message $message -tree $tree.sha -parents @($sha)
        # update head to point at new commint
        Set-GitHubCommit -headers $headers -Repo $Repo -Org $Org -server $server -ref $ref -sha $newCommit.sha
    }
    catch{$Error[0]}
}
#endregion

##########################################################################################################################
Export-ModuleMember -Function *