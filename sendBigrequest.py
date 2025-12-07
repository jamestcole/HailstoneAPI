import requests

url = "https://10c5rkcb49.execute-api.eu-west-1.amazonaws.com/prod/hailstone"
resp = requests.post(url, json={"start": 1001})
print(resp.status_code)
print(resp.json())
