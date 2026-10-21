import csv
import json
import urllib.request
import ssl

import os

script_dir = os.path.dirname(os.path.abspath(__file__))
base_dir = os.path.dirname(script_dir)
datasets_dir = os.path.join(base_dir, "datasets")
csv_path = os.path.join(datasets_dir, "ACCESS_REQUEST_TICKETS.csv")

search_service = "t020-srch-36de74"
names_path = os.path.join(base_dir, "names.json")
if os.path.exists(names_path):
    with open(names_path, "r", encoding="utf-8") as nf:
        names_data = json.load(nf)
        search_service = names_data.get("SearchService", search_service)

endpoint = os.environ.get("SEARCH_ENDPOINT", f"https://{search_service}.search.windows.net/indexes/ticket-text/docs/index?api-version=2024-07-01")
api_key = os.environ.get("SEARCH_API_KEY", "")

docs = []
with open(csv_path, mode="r", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        docs.append({
            "@search.action": "mergeOrUpload",
            "ticketId": row["Ticket_ID"],
            "ticketText": f"Manual access request for {row['Entitlement_ID']} under role {row['Business_Role_ID']}. Priority: {row['Priority']}. Auto-assigned expected: {row['Auto_Assigned_Expected']}.",
            "ticketType": row["Request_Type"],
            "contextCode": row["Business_Role_ID"]
        })

print(f"Loaded {len(docs)} tickets from CSV.")

# Upload in batches of 100
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

for i in range(0, len(docs), 100):
    batch = docs[i:i+100]
    payload = json.dumps({"value": batch}).encode("utf-8")
    req = urllib.request.Request(endpoint, data=payload, headers={
        "Content-Type": "application/json",
        "api-key": api_key,
        "Host": "team20-srch-204508.search.windows.net"
    }, method="POST")
    with urllib.request.urlopen(req, context=ctx) as resp:
        print(f"Uploaded batch {i//100 + 1}/{(len(docs)+99)//100}: Status {resp.status}")

print("All tickets successfully indexed into Azure AI Search team20-srch-204508!")
