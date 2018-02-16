---
external help file: UMN-Github-help.xml
Module Name: UMN-Github
online version: 
schema: 2.0.0
---

# New-GitHubHeader

## SYNOPSIS
Create Header to be consumed by all other functions

## SYNTAX

### creds
```
New-GitHubHeader -psCreds <PSCredential>
```

### token
```
New-GitHubHeader -authToken <String>
```

## DESCRIPTION
Create Header to be consumed by all other functions

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```

```

## PARAMETERS

### -psCreds
PScredential composed of your username/password to Git Server

```yaml
Type: PSCredential
Parameter Sets: creds
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -authToken
Use instead of user/pass, personal auth token

```yaml
Type: String
Parameter Sets: token
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Author: Travis Sobeck
LASTEDIT: 6/20/2017

## RELATED LINKS

