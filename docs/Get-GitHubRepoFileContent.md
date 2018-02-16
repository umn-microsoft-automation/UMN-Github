---
external help file: UMN-Github-help.xml
Module Name: UMN-Github
online version: 
schema: 2.0.0
---

# Get-GitHubRepoFileContent

## SYNOPSIS
Gets and then returns the contents of a GitHub repo file.

## SYNTAX

```
Get-GitHubRepoFileContent [-headers] <Hashtable> [-File] <String> [-Repo] <String> [-Org] <String>
 [[-server] <String>]
```

## DESCRIPTION
Takes in a username, password, filename, repository, organization and then returns the contents
of a file from the GitHub repository.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$GitHubHeaders = New-GitHubHeader -psCreds (Get-Credential)
```

Get-GitHubRepoFile -headers $GitHubHeaders -File "psscript.ps1" -Repo "MyFakeReop" -Org "MyFakeOrg" -server "github.foo.bar"

## PARAMETERS

### -headers
Get this from New-GitHubHeader

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -File
Filename string which needs to be downloaded from the repository. 
This should be the path to the file if it's not
in the root of the repository for example "fizz/buzz.txt" and keep in mind it should be the forward slashes.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Repo
Repository name string which is used to identify which repository under the organization to go into.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Org
Organization name string which is used to identify which organization in the GitHub instance to go into.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -server
An optional parameter for the fully qualified domain name of a github server, defaults to github.com but can be an internal
enterprise server.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: Github.com
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Name: Get-GitHubRepoFile
Author: Jeff Bolduan
LASTEDIT:  10/26/2017

## RELATED LINKS

