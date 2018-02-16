---
external help file: UMN-Github-help.xml
Module Name: UMN-Github
online version: 
schema: 2.0.0
---

# Set-GitHubCommit

## SYNOPSIS
Update a reference to a new Commit

## SYNTAX

```
Set-GitHubCommit [-headers] <Hashtable> [-Repo] <String> [-Org] <String> [-ref] <String> [-sha] <String>
 [[-server] <String>]
```

## DESCRIPTION
Update a reference to a new Commit

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```

```

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

### -ref
ref to be updated

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

### -sha
SHA to update reference to, get this from New-GitHubCommit

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
Author: Travis Sobeck
LASTEDIT: 6/20/2017

## RELATED LINKS

