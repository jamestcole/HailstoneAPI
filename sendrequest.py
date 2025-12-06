import requests

url = "https://abc123xyz.execute-api.eu-west-1.amazonaws.com/prod/hailstone"

payload = {
    "start": 27
}

response = requests.post(url, json=payload)

print("Status:", response.status_code)
print("Response JSON:", response.json())