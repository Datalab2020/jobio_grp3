#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import yaml, requests, pprint, json
from pymongo import MongoClient
import urllib.parse
from flatten import flatten_json
import time
from requests.exceptions import ConnectionError

confAll = yaml.safe_load(open('config.yaml', 'r'))
print(confAll)

conf = confAll['mongo']
mdp = urllib.parse.quote_plus(conf["password"])
print(mdp)
auth = 'mongodb://%s:%s@%s/?authSource=%s' % (conf['username'], mdp, conf['host'], conf['authSource'])

print(auth)
print("mongo conn:", auth)
client = MongoClient(auth)

db = client['bdd_ecoquelet']
collec = db['test_job']
#~ collec.save({"event": "test"})

conf = confAll['pole_emploi']
print('conf:', conf)

def get_token():
    # On renseigne les variables utilisées pour la requète POST
    URL = 'https://entreprise.pole-emploi.fr/connexion/oauth2/access_token'
    app = 'api_offresdemploiv2 o2dsoffre'
    scope="application_"+conf['PAR']+" "+app
    print('scope: ', scope)
    
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

# valide_sec = resp['expires_in']

def get_content():
    i = 0
    for code in codeROME:
            for nb in nbEnrg:
                    params = {"sort":1, "range": nb, "codeROME": code}
                    print(params)
                    
                    headers = {"Authorization": "Bearer "+token,
                                "Accept":"application/json"}
                    
                    call = requests.get(url, params = params, headers = headers)
                    print(call)
                    response = call.content
                    if response == b'':
                        print("NO CONTENT")
                        break
                    else:
                        print("Ok")
                        response = call.content
                        data = json.loads(response)
                        # pprint.pprint(data)
                        for block in data["resultats"]:
                            call = requests.get("https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/{0}".format(block["id"]), headers=headers)
                            responseb = call.content
                            datab = json.loads(responseb)
                            datab = flatten_json(datab)
                            collec.update_one({"id": block["id"]}, {"$set":datab}, True)
                            last_params = params
                            i = i+1
                            print("ALL DONE ", i)
                            return last_params
                            

url = 'https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search'
codeROME = ["M1805", "M1802", "M1403", "M1808", "M1601", "M1810"]
nbEnrg = ["0-149", "150-299", "300-449", "450-599", "600-749", "750-899", "900-1049"]

offre = []

token = get_token()
i=0
while True:
    try:
        last_params = get_content()
        for code in codeROME:
            for nb in nbEnrg:
                # nb = nbEnrg.pop()
                params = {"sort":1, "range": nb, "codeROME": code}
                print(params)
                
                headers = {"Authorization": "Bearer "+token,
                            "Accept":"application/json"}
                
                call = requests.get(url, params = params, headers = headers)
                print(call)
                response = call.content
                if response == b'':
                    print("NO CONTENT")
                    break
                else:
                    print("Ok")
                    response = call.content
                    data = json.loads(response)
                    # pprint.pprint(data)
                    for block in data["resultats"]:
                        call = requests.get("https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/{0}".format(block["id"]), headers=headers)
                        responseb = call.content
                        datab = json.loads(responseb)
                        datab = flatten_json(datab)
                        collec.update_one({"id": block["id"]}, {"$set":datab}, True)
                        last_params = params
                        i = i+1
                        # print("ALL DONE ", i)
    except ValueError or ConnectionError:
        token = get_token()
        for code in codeROME:
            for nb in nbEnrg:
                # nb = nbEnrg.pop()
                params = last_params
                params = {"sort":1, "range": nb, "codeROME": code}
                print(params)
                
                headers = {"Authorization": "Bearer "+token,
                            "Accept":"application/json"}
                
                call = requests.get(url, params = params, headers = headers)
                print(call)
                response = call.content
                if response == b'':
                    print("NO CONTENT")
                    break
                else:
                    print("Ok")
                    response = call.content
                    data = json.loads(response)
                    # pprint.pprint(data)
                    for block in data["resultats"]:
                        call = requests.get("https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/{0}".format(block["id"]), headers=headers)
                        responseb = call.content
                        datab = json.loads(responseb)
                        datab = flatten_json(datab)
                        collec.update_one({"id": block["id"]}, {"$set":datab}, True)
                        last_params = params
                        i = i+1
                        # print("ALL DONE ", i)
        continue 
        