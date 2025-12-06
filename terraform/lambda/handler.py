import json
import os
import boto3
from decimal import Decimal
from logic import hailstone

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ.get("TABLE_NAME") or "hailstone-api-results")

def handler(event, context):

    # Parse and validate input
    try:
        body = json.loads(event.get("body", "{}"))
        n = int(body.get("start"))
        if n < 1:
            raise ValueError("start must be a positive integer")
    except Exception as e:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": str(e)})
        }

    # For large values, check DynamoDB first
    if n > 1000:
        response = table.get_item(Key={"start": n})
        if "Item" in response:
            item = response["Item"]
            return {
                "statusCode": 200,
                "body": json.dumps({
                    "start": int(item["start"]),
                    "steps": int(item["steps"]),
                    "sequence": [int(x) for x in item["sequence"]],
                    "finished": bool(item["finished"]),
                    "source": "cached"
                })
            }

    # Compute result
    steps, sequence, finished = hailstone(n)

    # Store result for large numbers
    if n > 1000:
        table.put_item(Item={
            "start": n,
            "steps": steps,
            "finished": finished,
            "sequence": [Decimal(x) for x in sequence]
        })

    # Response
    return {
        "statusCode": 200,
        "body": json.dumps({
            "start": n,
            "steps": steps,
            "sequence": sequence,
            "finished": finished,
            "source": "computed"
        })
    }
