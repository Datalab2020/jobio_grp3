#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May  6 14:18:25 2021

@author: formateur
"""
from math import *
import yaml
import requests
import pprint
import json
from pymongo import MongoClient

codeROME = ["M1805", "M1802", "M1403", "M1808", "M1601", "M1810"]
nbEnrg = ["0-149", "150-299", "300-449", "450-599", "600-749", "750-899", "900-1049"]


def flatten_json(json):
    out = {}
    def flatten(x, name=''):
        if type(x) is dict:
            for a in x:
                flatten(x[a], name + a + '_')
        elif type(x) is list:
            i = 0
            for a in x:
                flatten(a, name + str(i) + '_')
                i += 1
        else:
            out[name[:-1]] = x
    flatten(json)
    return out

confa = yaml.safe_load(open('config.yml', 'r'))
print(confa)
confb = confa['poleEmp']
print('conf:', confb)


client = MongoClient('mongodb://%s:%s@%s/?authSource=%s'
% (confb['user'], confb['mdp'],'127.0.0.1', 'admin'))
db = client['bdd_projet9_secf']
collec = db['offres']

# On renseigne les variables utilisées pour la requète POST
URL = 'https://entreprise.pole-emploi.fr/connexion/oautimport timeimport timeh2/access_token'
app = 'api_offresdemploiv2 o2dsoffre'
scope="application_"+confb['IDC']+" "+app
print('scope: ', scope)

params={"realm":"/partenaire"}
post_data = {"grant_type": "client_credentials",
	"client_id": confb['IDC'],
	"client_secret": confb['CS'],
	"scope": scope}
headers = {"content-type": "application/x-www-form-urlencoded"}

# Récupération du token
reqOrigin = requests.post(URL, params=params, data=post_data, headers=headers)
respOrigin = reqOrigin.json()
pprint.pprint(respOrigin)
# Le token !!!
token = respOrigin['access_token']
print("access token: ", token)
print("-------------------------------------------------")

# Execution de la requète
url = 'https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search'
urlb = "https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/"
headers = {"Authorization": "Bearer "+token,
           "Accept":"application/json"}


for code in codeROME:
    for nb in nbEnrg:
            params = {"sort":"1", "range": nb, "codeROME": code}
            print(params)
            
            call = requests.get(url, params = params, headers = headers)
            print(call)
            response = call.content
            if response is b'':
                break
            else:
                response = call.content
                data = json.loads(response)
                # pprint.pprint(data)
                # collec.insert_one(data)
                for block in data["resultats"]:
                    # print(block["id"])
                    # offre.append(block["id"])
                    call = requests.get("https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/{0}".format(block["id"]), headers = headers)
                    responseb = call.content
                    datab = json.loads(responseb)
                    # pprint.pprint(datab)
                    flatten_json(datab)
                    collec.update_one({"id": block["id"]}, {"$set":datab}, True)