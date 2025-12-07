import json
import os
import boto3
from decimal import Decimal
from logic import hailstone

dynamodb = boto3.resource("dynamodb")
table_name = os.environ.get("TABLE_NAME", "hailstone-api-results")
table = dynamodb.Table(table_name)

def handler(event, context):
    # HTTP API v2: body is a JSON string
    try:
        body_str = event.get("body", "{}")
        body = json.loads(body_str)
        n = int(body.get("start"))
        if n < 1:
            raise ValueError("start must be a positive integer")
    except Exception as e:
        return {
            "statusCode": 400,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)})
        }

    # Optional cache: only for large numbers
    if n > 1000:
        resp = table.get_item(Key={"start": n})
        if "Item" in resp:
            item = resp["Item"]
            return {
                "statusCode": 200,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({
                    "start": int(item["start"]),
                    "steps": int(item["steps"]),
                    "sequence": [int(x) for x in item["sequence"]],
                    "finished": bool(item["finished"]),
                    "source": "cached"
                })
            }

    # Compute Hailstone
    steps, sequence, finished = hailstone(n)

    # Store result only for large numbers
    if n > 1000:
        table.put_item(
            Item={
                "start": n,
                "steps": steps,
                "finished": finished,
                "sequence": [Decimal(x) for x in sequence]
            }
        )

    # Return synchronous response
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({
            "start": n,
            "steps": steps,
            "sequence": sequence,
            "finished": finished,
            "source": "computed"
        })
    }

