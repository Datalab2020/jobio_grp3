#!/usr/bin/python3

import yaml
import requests
import pprint

confa = yaml.safe_load(open('/home/formateur/config.yml', 'r'))
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

# Utilisation du token pour faire une requête anotea
URL = 'https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search'
params={"range":"0-30",
        "publieeDepuis":31,
        "codeROME":"K1903"}
headers = {"Authorization": "Bearer "+token}
req = requests.get(URL, params=params, headers=headers)
# print(req.content)

rap = req.status_code
print(rap)
resp = req.json()
# pprint.pprint(resp)
