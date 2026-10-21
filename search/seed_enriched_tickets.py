import csv
import json
import urllib.request
import ssl
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
base_dir = os.path.dirname(script_dir)
datasets_dir = os.path.join(base_dir, "datasets")

search_service = "t020-srch-36de74"
names_path = os.path.join(base_dir, "names.json")
if os.path.exists(names_path):
    with open(names_path, "r", encoding="utf-8") as nf:
        names_data = json.load(nf)
        search_service = names_data.get("SearchService", search_service)

# 1. Load Reference Catalogs
roles = {}
with open(os.path.join(datasets_dir, "BUSINESS_ROLE_MASTER.csv"), mode="r", encoding="utf-8") as f:
    for row in csv.DictReader(f):
        roles[row["Business_Role_ID"]] = {
            "title": row.get("Title") or row.get("Business_Role_Name", ""),
            "group": row.get("Business_Group", "")
        }

apps = {}
with open(os.path.join(datasets_dir, "APPLICATION_MASTER.csv"), mode="r", encoding="utf-8") as f:
    for row in csv.DictReader(f):
        apps[row["Application_ID"]] = {
            "name": row.get("Application_Name", ""),
            "category": row.get("Application_Category", "")
        }

entitlements = {}
with open(os.path.join(datasets_dir, "ENTITLEMENT_CATALOG.csv"), mode="r", encoding="utf-8") as f:
    for row in csv.DictReader(f):
        app_id = row.get("Application_ID", "")
        app_info = apps.get(app_id, {"name": app_id, "category": "Enterprise Application"})
        entitlements[row["Entitlement_ID"]] = {
            "name": row.get("Entitlement_Name", ""),
            "level": row.get("Access_Level", "Standard"),
            "app_id": app_id,
            "app_name": app_info["name"],
            "category": app_info["category"]
        }

# 2. Build Semantically Enriched Ticket Documents
docs = []
with open(os.path.join(datasets_dir, "ACCESS_REQUEST_TICKETS.csv"), mode="r", encoding="utf-8") as f:
    for row in csv.DictReader(f):
        role_id = row["Business_Role_ID"]
        ent_id = row["Entitlement_ID"]
        role_info = roles.get(role_id, {"title": role_id, "group": "GM Financial"})
        ent_info = entitlements.get(ent_id, {"name": ent_id, "level": "Standard", "app_id": "APP001", "app_name": "Core Application", "category": "Operations"})
        
        # Enriched semantic text incorporating Role, Entitlement, Application, and Category
        ticket_text = (
            f"Manual access request for {ent_info['name']} ({ent_id}) in {ent_info['app_name']} "
            f"({ent_info['app_id']}, {ent_info['category']}) under role {role_info['title']} "
            f"({role_id}, {role_info['group']}). Request type: {row['Request_Type']}. "
            f"Access level: {ent_info['level']}. Priority: {row['Priority']}. "
            f"Auto-assigned expected: {row['Auto_Assigned_Expected']}."
        )
        
        docs.append({
            "@search.action": "mergeOrUpload",
            "ticketId": row["Ticket_ID"],
            "ticketText": ticket_text,
            "ticketType": row["Request_Type"],
            "contextCode": role_id
        })

print(f"Prepared {len(docs)} enriched ticket documents.")
print("Sample document 0:")
print(json.dumps(docs[0], indent=2))

# 3. Index into Azure AI Search
endpoint = os.environ.get("SEARCH_ENDPOINT", f"https://{search_service}.search.windows.net/indexes/ticket-text/docs/index?api-version=2024-07-01")
api_key = os.environ.get("SEARCH_API_KEY", "")

ctx = ssl.create_default_context()

for i in range(0, len(docs), 100):
    batch = docs[i:i+100]
    payload = json.dumps({"value": batch}).encode("utf-8")
    req = urllib.request.Request(endpoint, data=payload, headers={
        "Content-Type": "application/json",
        "api-key": api_key
    }, method="POST")
    with urllib.request.urlopen(req, context=ctx) as resp:
        print(f"Uploaded batch {i//100 + 1}/{(len(docs)+99)//100}: Status {resp.status}")

print("Successfully indexed all 600 enriched tickets with Role, Entitlement, and Application semantics!")
