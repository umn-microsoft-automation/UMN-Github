---
external help file: UMN-Github-help.xml
Module Name: UMN-Github
online version: 
schema: 2.0.0
---

# Get-GitHubRepoFile

## SYNOPSIS
Get a file from a GitHub Repo.

## SYNTAX

```
Get-GitHubRepoFile [[-headers] <Hashtable>] [-File] <String> [-Repo] <String> [-Org] <String>
 [-OutFile] <String> [[-server] <String>]
```

## DESCRIPTION
Takes in a username, password, filename, repository, organization and a file to output to then downloads the file
from the repository.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-GitHubRepoFile -Username "Test" -Password "pass" -File "psscript.ps1" -Repo "MyFakeReop" -Org "MyFakeOrg" -OutFile "C:\temp\psscript.ps1" -server "ServerFQDN"
```

## PARAMETERS

### -headers
Get this from New-GitHubHeader

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -File
Filename string which needs to be downloaded from the repository.

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

### -OutFile
A string representing the local file path to download the GitHub file to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -server
The Default is public github but you can se this if you are running your own Enterprise Github server

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: Github.com
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Name: Get-GitHubRepoFile
Author: Jeff Bolduan
LASTEDIT:  4/26/2017

## RELATED LINKS

