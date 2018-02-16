---
external help file: UMN-Github-help.xml
Module Name: UMN-Github
online version: 
schema: 2.0.0
---

# Get-GitHubRepoZip

## SYNOPSIS
Get a GitHub Repo and download to zip file.

## SYNTAX

```
Get-GitHubRepoZip [[-headers] <Hashtable>] [-Org] <String> [-repo] <String> [-OutFile] <String> [-ref] <String>
 [[-server] <String>]
```

## DESCRIPTION
Takes in a PSCredention or Auth Key if needed, repository, organization and a file to output to then downloads the file
from the repository.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-GitHubRepoZip -authToken $authToken -Repo $repo -Org $org -OutFile $outFile -server "ServerFQDN"
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

### -Org
Organization name string which is used to identify which organization in the GitHub instance to go into.

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

### -repo
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

### -OutFile
A string representing the local file path to download the GitHub Zip file to.

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

### -ref
{{Fill ref Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 5
Default value: Master
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

## RELATED LINKS

