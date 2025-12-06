import boto3
from decimal import Decimal

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("HailstoneResults")

def handler(event, context):
    n = event["start"]

    # For large numbers, try to read from DynamoDB first
    if n > 1000:
        resp = table.get_item(Key={"start": n})
        if "Item" in resp:
            # Found cached result, return immediately
            item = resp["Item"]
            return {
                "start": int(item["start"]),
                "steps": int(item["steps"]),
                "finished": bool(item["finished"]),
                "sequence": [int(x) for x in item["sequence"]],
                "source": "cache"
            }

    # Otherwise compute the Hailstone result (pseudo-call)
    steps, sequence, finished = hailstone(n)

    # Store result for future use (DynamoDB requires Decimal for numbers)
    table.put_item(
        Item={
            "start": n,
            "steps": steps,
            "finished": finished,
            "sequence": [Decimal(x) for x in sequence]
        }
    )

    return {
        "start": n,
        "steps": steps,
        "finished": finished,
        "sequence": sequence,
        "source": "computed"
    }
