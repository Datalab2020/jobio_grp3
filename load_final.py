#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import yaml, requests, pprint, json
from pymongo import MongoClient
import urllib.parse
from flatten import flatten_json
import datetime as dt
import time
from requests.exceptions import ConnectionError
import urllib.error

confAll = yaml.safe_load(open('config.yaml', 'r'))
# print(confAll)

conf = confAll['mongo']
mdp = urllib.parse.quote_plus(conf["password"])
auth = 'mongodb://%s:%s@%s/?authSource=%s' % (conf['username'], mdp, conf['host'], conf['authSource'])

# print(auth)
# print("mongo conn:", auth)
client = MongoClient(auth)

db = client['bdd_ecoquelet']
collec = db['test_job']
#~ collec.save({"event": "test"})

conf = confAll['pole_emploi']
# print('conf:', conf)

now = dt.datetime.now()
print("Il est: ", now)

def get_token():
    # On renseigne les variables utilisées pour la requète POST
    URL = 'https://entreprise.pole-emploi.fr/connexion/oauth2/access_token'
    app = 'api_offresdemploiv2 o2dsoffre'
    scope="application_"+conf['PAR']+" "+app
    # print('scope: ', scope)
    
    params={"realm":"/partenaire"}
    post_data = {"grant_type": "client_credentials",
            	"client_id": conf['PAR'],
            	"client_secret": conf['SEC'],
            	"scope": scope}
    headers = {"content-type": "application/x-www-form-urlencoded"}
    
    # Execution de la requète
    req = requests.post(URL, params=params, data=post_data, headers=headers)
    resp = req.json()
    pprint.pprint(resp)
    
    # Le token !!!
    token = resp['access_token']
    print("access token: ", token)
    print("-------------------------------------------------")
    return token

def get_params():
    params = {"sort":1, "range": nb, "codeROME": code}
    print(params)
    return params
    
def get_headers():
    headers = {"Authorization": "Bearer "+token,
                "Accept":"application/json"}
    return headers
    
def get_call():
    call = requests.get(url, params = params, headers = headers)
    print(call)
    return call

def load():
    call = requests.get("https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/{0}".format(block["id"]), headers=headers)
    responseb = call.content
    datab = json.loads(responseb)
    datab = flatten_json(datab)
    collec.update_one({"id": block["id"]}, {"$set":datab}, True)
    return params
                         
url = 'https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search'
codeROME = ["M1805", "M1802", "M1403", "M1808", "K1601", "M1810"]
nbEnrg = ["0-149", "150-299", "300-449", "450-599", "600-749", "750-899", "900-1049"]

offre = []

token = get_token()
i=0
while True:
    try:
        for code in codeROME:
            for nb in nbEnrg:
                params = get_params()
                headers = get_headers()
                call = get_call()
                response = call.content
                if response == b'':
                    print("NO CONTENT")
                    break
                else:
                    print("Ok")
                    response = call.content
                    data = json.loads(response)
                    for block in data["resultats"]:
                        params = load()
                        list_params = list(params.values())
                        last_codeROME = list_params[2]
                        
    except ValueError or ConnectionError:
        token = get_token()
        indexROME = codeROME.index(last_codeROME)
        del codeROME[:indexROME]
        for code in codeROME:
            for nb in nbEnrg:
                params = get_params()
                headers = get_headers()
                call = get_call()
                response = call.content
                if response == b'':
                    print("NO CONTENT")
                    break
                else:
                    print("Ok")
                    response = call.content
                    data = json.loads(response)
                    for block in data["resultats"]:
                        params = load()
                        stop_signal = {"sort":1, "range": "0-149", "codeROME": last_codeROME}
                        if params == stop_signal:
                            break
        continue
        