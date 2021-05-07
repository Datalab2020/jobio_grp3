#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May  6 14:18:25 2021

@author: formateur
"""

import yaml
import requests
import pprint
import json

codeROME = ["M1805", "M1802", "M1403", "M1808", "M1601", "M1810"]
nbEnrg = ["0-149", "150-299", "300-449", "450-599", "600-749", "750-899", "900-1049"]

confa = yaml.safe_load(open('config.yml', 'r'))
print(confa)
confb = confa['poleEmp']
print('conf:', confb)

# On renseigne les variables utilisées pour la requète POST
URL = 'https://entreprise.pole-emploi.fr/connexion/oauth2/access_token'
app = 'api_offresdemploiv2 o2dsoffre'
scope="application_"+confb['IDC']+" "+app
print('scope: ', scope)

params={"realm":"/partenaire"}
post_data = {"grant_type": "client_credentials",
	"client_id": confb['IDC'],
	"client_secret": confb['CS'],
	"scope": scope}
headers = {"content-type": "application/x-www-form-urlencoded"}

# Execution de la requète
reqOrigin = requests.post(URL, params=params, data=post_data, headers=headers)
respOrigin = reqOrigin.json()
pprint.pprint(respOrigin)
# Le token !!!
token = respOrigin['access_token']
print("access token: ", token)
print("-------------------------------------------------")

for code in codeROME:
    for nb in nbEnrg:
            params = {"sort":"1", "range": nb, "codeROME": code}
            print(params)
            
            headers = {"Authorization": "Bearer "+token,
                       "Accept":"application/json"}
            
            call = requests.get(URL, params = params, headers = headers)
            print(call)
            response = call.content
            if response is b'':
                print("NO CONTENT I QUIT")
                break
            else:
                print("MOTHERFUCKER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                response = call.content
                data = json.loads(response)
                # pprint.pprint(data)
                
                # the json file where the output must be stored 
                out_file = open("myfile.json", "w") 
                    
                json.dump(data, out_file, indent = 6) 
                
                out_file.close()