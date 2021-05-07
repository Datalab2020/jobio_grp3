#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May  5 14:24:06 2021

@author: formateur
"""

import requests
from pymongo import MongoClient
import config    


#co à mongoDB
client = MongoClient('mongodb://%s:%s@%s/?authSource=%s'
% (config.user, config.password,
'127.0.0.1', 'admin'))
db = client['bdd_grp1']
collec = db['groupe1_OFFICIEL']

urlForum = 'https://www.fun-mooc.fr/courses/course-v1:agrocampusouest+40004+session04/discussion/forum'


#cURL cookies ajax_login
cookies = {
    'csrftoken': 'E8kKUlJD1It69QA6jKYLgzCoFXGGx2p4',
    'atuserid': '%7B%22name%22%3A%22atuserid%22%2C%22val%22%3A%22368c4e33-a553-4d60-bbe5-213d40f97c9b%22%2C%22options%22%3A%7B%22end%22%3A%222022-02-19T09%3A00%3A33.893Z%22%2C%22path%22%3A%22%2F%22%7D%7D',
    'atidvisitor': '%7B%22name%22%3A%22atidvisitor%22%2C%22val%22%3A%7B%22vrn%22%3A%22-602676-%22%7D%2C%22options%22%3A%7B%22path%22%3A%22%2F%22%2C%22session%22%3A15724800%2C%22end%22%3A15724800%7D%7D',
    'acceptCookieFun': 'on',
    'edx_session': '9bmogh51gwamt6iqlno6faeaiejdoh8c',
}

headers = {
    'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:85.0) Gecko/20100101 Firefox/85.0',
    'Accept': '*/*',
    'Accept-Language': 'fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3',
    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    'X-Requested-With': 'XMLHttpRequest',
    'Origin': 'https://www.fun-mooc.fr',
    'Connection': 'keep-alive',
    'Referer': 'https://www.fun-mooc.fr/',
}

data = {
  'email': config.mail,
  'password': config.passfun,
  'csrfmiddlewaretoken': 'E8kKUlJD1It69QA6jKYLgzCoFXGGx2p4'
}

response = requests.post('https://www.fun-mooc.fr/login_ajax', headers=headers, cookies=cookies, data=data)


#récup token
log = (response.json())
newCook = (response.cookies)
#print(newCook)

#cURL récup nombre pages sur forum?ajax
params = (
    ('ajax', '1'),
    ('page', '1'),
    ('sort_key', 'date'),
    ('sort_order', 'desc'),
)

response = requests.get(urlForum, headers=headers, params=params, cookies=newCook)
base = (response.json())
nbPage = base["num_pages"] + 1
#print(nbPage)


#itération sur nbpage sur cURL forum?ajax pour récup des ID de fil
for i in range (1,nbPage):   
    params = (
        ('ajax', '1'),
        ('page', '{0}'.format(i)),
        ('sort_key', 'date'),
        ('sort_order', 'desc'),
        ('resp_skip', '0'),
        ('resp_limit', '25'),
    )   
    response = requests.get(urlForum, headers=headers, params=params, cookies=newCook) 
    whole = (response.json())
    #print(whole)
    #Récup de chaque fil via chaque ID présentes sur les pages du cURL précédent
    
    for block in whole["discussion_data"]:
        print(block["id"],"---",block["title"])
        
        # discu = block["id"]
        
        urlThread = 'https://www.fun-mooc.fr/courses/course-v1:agrocampusouest+40004+session04/discussion/forum/e928f62344fcada452a15419f529a7d142095a00/threads/{0}'.format(block["id"])

        response = requests.get(urlThread, headers=headers, params=params, cookies=newCook)
            
        kek = (response.json())
        #envois dans la table
        collec.insert_one(kek)