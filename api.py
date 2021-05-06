#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import requests, yaml
import json, pprint
import pandas as pd


conf = yaml.safe_load(open('config.yaml'))
print(conf)
conf = conf['pole_emploi']
print(conf)
url = 'https://entreprise.pole-emploi.fr/connexion/oauth2/access_token'
app = 'api_offresdemploiv2 o2dsoffre'
scope = f"application_{conf['PAR']} {app}"

params = {"realm":"/partenaire"}
print(params)
post_data = {"grant_type": "client_credentials",
        "client_id": conf['PAR'],
        "client_secret": conf['SEC'],
        "scope": scope}
print(post_data)
headers = {"content-type": "application/x-www-form-urlencoded"}
call = requests.post(url, params = params, data = post_data, headers = headers)
resp = call.json()
print(resp)

token = resp['access_token']
print(token)

code = 'metiers'
url = 'https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search'

params = {}
nbEnrg = ["0-149", "150-299", "300-449", "450-599", "600-749", "750-899", "900-1049"]  
codeROME = ["M1805", "M1802", "M1403", "M1808", "M1601", "M1810"]
for nb in nbEnrg:
    for code in codeROME:
        params = {"sort":"1", "range": nb, "codeROME": code}
        print(params)

headers = {"Authorization": "Bearer "+token,
           "Accept":"application/json"}

call = requests.get(url, params = params, headers = headers)
resp = call.json()
print(call)

response = call.content
data = json.loads(response)
pprint.pprint(data)

# the json file where the output must be stored 
out_file = open("myfile.json", "w") 
    
json.dump(data, out_file, indent = 6) 
    
out_file.close()