import requests

accessToken = "fc53a14c-add9-4416-8d2a-f16e38215342"

headers = {
	'X-Auth-Token': accessToken,
	'X-Api-Key': '88ac7ea8359d49f48eda24ff7ebc18dc',
	'Date': 'Wed, 13 Apr 2016 12:07:37 GMT'
}

# r = requests.get('https://api.inthegra.strans.teresina.pi.gov.br/v1/linhas', headers=headers)
# for line in r.json():
# 	print(line['CodigoLinha'])


responseLine = requests.get('https://api.inthegra.strans.teresina.pi.gov.br/v1/paradasLinha?busca={}'.format('T534'), headers=headers)
paradas = responseLine.json()['Paradas']
for parada in paradas:
	print(" {}".format(parada['CodigoParada']))

