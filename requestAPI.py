# -*- coding: utf-8 -*-
"""
Created on Tue May  4 07:10:56 2021

@author: Greta
"""

import yaml, requests, pprint
import os

dir = r'C:\Users\Greta\Documents\GitHub\jobio_grp3'
os.chdir(dir)

conf = yaml.safe_load(open('config.yml', 'r'))
print(conf)
conf = conf['poleEmp']
print('conf:', conf)

# On renseigne les variables utilisées pour la requête POST
URL = 'https://entreprise.pole-emploi.fr/connexion/oauth2/access_token'
app = 'api_offresdemploiv2 o2dsoffre'
scope="application_"+conf['IDC']+" "+app
print('scope: ', scope)

params={"realm":"/partenaire"}
post_data = {"grant_type": "client_credentials",
	"client_id": conf['IDC'],
	"client_secret": conf['CS'],
	"scope": scope}
headers = {"content-type": "application/x-www-form-urlencoded"}

# Execution de la requête
req = requests.post(URL, params=params, data=post_data, headers=headers)
resp = req.json()
pprint.pprint(resp)
# Le token !!!
token = resp['access_token']
print("access token: ", token)
print("-------------------------------------------------")

# Utilisation du token pour faire une requête anotea
URL = 'https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search'
params={"qualification":0,
        "motsCles":"informatique",
        "commune":[51069,76322,46083,12172,28117],
        "origineOffre":2}
headers = {"Authorization": "Bearer "+token}

req = requests.get(URL, params=params, headers=headers)
print(req.content)
resp = req.json()