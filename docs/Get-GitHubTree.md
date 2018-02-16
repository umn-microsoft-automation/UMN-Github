---
external help file: UMN-Github-help.xml
Module Name: UMN-Github
online version: 
schema: 2.0.0
---

# Get-GitHubTree

## SYNOPSIS
Get a specific reference or all references for a specific repo

## SYNTAX

```
Get-GitHubTree [[-headers] <Hashtable>] [-Repo] <String> [-Org] <String> [-sha] <String> [-recurse]
 [[-server] <String>]
```

## DESCRIPTION
Get a specific reference or all references for a specific repo, use -ref for a specific reference

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```

```

### -------------------------- EXAMPLE 2 --------------------------
```

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

### -Repo
Repository name string which is used to identify which repository under the organization to go into.

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

### -Org
Organization name string which is used to identify which organization in the GitHub instance to go into.

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

### -sha
Sha of tree, use (Get-GitHubCommit -authToken $ghAuthToken -Repo $Repo -Org $Org -server $server -sha $sha).tree.sha to get the sha you need

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

### -recurse
{{Fill recurse Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
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
Position: 5
Default value: Github.com
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Name: Get-GitHubRepoRefs
Author: Travis Sobeck
LASTEDIT: 4/26/2017

## RELATED LINKS

