#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May  6 11:01:14 2021

@author: formateur
"""
token= "d"
requests = "e"


listROME = ["M1805", "M1802", "M1403", "M1808", "M1601", "M1810"]
nbEnrg = ["0-149", "150-299", "300-449", "450-599", "600-749", "750-899", "900-1049", "1050-1149"]  

x = 0

y = 0


URL = 'https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search'
params={"range":nbEnrg[x],
        "codeROME":listROME[y]}
headers = {"Authorization": "Bearer "+token}
req = requests.get(URL, params=params, headers=headers)

rap = req.status_code
print(rap)
resp = req.json()
# pprint.pprint(resp)

if resp is not b' ' :
        URL = 'https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search'
        params={"range":nbEnrg[x],
                "codeROME":listROME[y]}
        headers = {"Authorization": "Bearer "+token}
        req = requests.get(URL, params=params, headers=headers)
        x += 1 
else:
        y += 1
        URL = 'https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search'
        params={"range":nbEnrg[x],
                "codeROME":listROME[y]}
        headers = {"Authorization": "Bearer "+token}
        req = requests.get(URL, params=params, headers=headers)
        

# for nb in listROME:
#     URL = 'https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search'
#     params={"range":nbEnrg[x],
#         "codeROME":listROME[y]}
#     headers = {"Authorization": "Bearer "+token}
#     req = requests.get(URL, params=params, headers=headers)
#     if req.status_code == 206 :
#         while req.status_code == 206 :
#             x += 1
#             URL = 'https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search'
#             params={"range":nbEnrg[x],
#                     "codeROME":listROME[y]}
#             headers = {"Authorization": "Bearer "+token}
#             req = requests.get(URL, params=params, headers=headers)
#     elif req.status_code == 200 :
#         y += 1
#         URL = 'https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search'
#         params={"range":nbEnrg[x],
#                 "codeROME":listROME[y]}
#         headers = {"Authorization": "Bearer "+token}
#         req = requests.get(URL, params=params, headers=headers)
#     else :
#         req.status_code == 400
        
        
# # if resp is none:
    
    
# listROME = ["M1805", "M1802", "M1403", "M1808", "M1601", "M1810"]
# nbEnrg = ["0-149", "150-299", "300-449", "450-599", "600-749", "750-899", "900-1049", "1050-1149"]  
# x = 0
# y = 0

# for nb in listROME:
#     while resp is not None :
#         URL = 'https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search'
#         params={"range":nbEnrg[x],
#                 "codeROME":listROME[y]}
#         headers = {"Authorization": "Bearer "+token}
#         req = requests.get(URL, params=params, headers=headers)
#         x += 1 
#     elif resp is None :
#         y += 1
#         URL = 'https://api.emploi-store.fr/partenaire/offresdemploi/v2/offres/search'
#         params={"range":nbEnrg[x],
#                 "codeROME":listROME[y]}
#         headers = {"Authorization": "Bearer "+token}
#         req = requests.get(URL, params=params, headers=headers)
        
        
        
        
        
        
        
        