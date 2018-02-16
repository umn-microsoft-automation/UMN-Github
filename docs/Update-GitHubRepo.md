---
external help file: UMN-Github-help.xml
Module Name: UMN-Github
online version: 
schema: 2.0.0
---

# Update-GitHubRepo

## SYNOPSIS
Get a specific reference or all references for a specific repo

## SYNTAX

```
Update-GitHubRepo [-headers] <Hashtable> [-Repo] <String> [-Org] <String> [-ref] <String> [-message] <String>
 [-path] <String> [-filePath] <String> [[-server] <String>]
```

## DESCRIPTION
Get a specific reference or all references for a specific repo, use -ref for a specific reference

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
Specific ref, run the command without it to get a list example would be.

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

### -message
The commit message

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

### -path
path to file in github

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filePath
Path to file to be added/modified

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 7
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
Position: 8
Default value: Github.com
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Author: Travis Sobeck
LASTEDIT: 4/26/2017

## RELATED LINKS

