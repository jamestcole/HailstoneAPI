import requests
import concurrent.futures
import random
import json

API_URL = "https://10c5rkcb49.execute-api.eu-west-1.amazonaws.com/prod/hailstone"

def send_request(n):
    try:
        resp = requests.post(API_URL, json={"start": n}, timeout=5)
        return (n, resp.status_code, resp.json())
    except Exception as e:
        return (n, "ERROR", str(e))

def main():
    numbers = [random.randint(2, 10000) for _ in range(1000)]

    print(f"Sending 100 concurrent requests: {numbers}")

    with concurrent.futures.ThreadPoolExecutor(max_workers=1000) as executor:
        results = executor.map(send_request, numbers)

    print("\nResponses:")
    for r in results:
        print(r)

if __name__ == "__main__":
    main()
