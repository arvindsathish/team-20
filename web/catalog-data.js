// Pre-seeded baseline enterprise catalog generated from dataset master CSVs
// Includes complete metadata for all 40 applications, 250 entitlements with AD groups, and 75 business roles

export const BASELINE_APPLICATIONS = {
    "APP001":  {
                   "id":  "APP001",
                   "name":  "Avenra Ledger Desk",
                   "category":  "Finance Operations"
               },
    "APP002":  {
                   "id":  "APP002",
                   "name":  "Belyx Report Hub",
                   "category":  "Finance Operations"
               },
    "APP003":  {
                   "id":  "APP003",
                   "name":  "Calora Document Vault",
                   "category":  "Finance Operations"
               },
    "APP004":  {
                   "id":  "APP004",
                   "name":  "Dovari Service Queue",
                   "category":  "Finance Operations"
               },
    "APP005":  {
                   "id":  "APP005",
                   "name":  "Elenix Case Board",
                   "category":  "Finance Operations"
               },
    "APP006":  {
                   "id":  "APP006",
                   "name":  "Fentara Payment Studio",
                   "category":  "Finance Operations"
               },
    "APP007":  {
                   "id":  "APP007",
                   "name":  "Gavelo Risk Monitor",
                   "category":  "Finance Operations"
               },
    "APP008":  {
                   "id":  "APP008",
                   "name":  "Havora Access Console",
                   "category":  "Finance Operations"
               },
    "APP009":  {
                   "id":  "APP009",
                   "name":  "Iverna Ledger Desk",
                   "category":  "Reporting"
               },
    "APP010":  {
                   "id":  "APP010",
                   "name":  "Jalven Report Hub",
                   "category":  "Reporting"
               },
    "APP011":  {
                   "id":  "APP011",
                   "name":  "Korevi Document Vault",
                   "category":  "Reporting"
               },
    "APP012":  {
                   "id":  "APP012",
                   "name":  "Lunaro Service Queue",
                   "category":  "Reporting"
               },
    "APP013":  {
                   "id":  "APP013",
                   "name":  "Mavira Case Board",
                   "category":  "Reporting"
               },
    "APP014":  {
                   "id":  "APP014",
                   "name":  "Nerovo Payment Studio",
                   "category":  "Reporting"
               },
    "APP015":  {
                   "id":  "APP015",
                   "name":  "Orvexa Risk Monitor",
                   "category":  "Reporting"
               },
    "APP016":  {
                   "id":  "APP016",
                   "name":  "Pavelo Access Console",
                   "category":  "Reporting"
               },
    "APP017":  {
                   "id":  "APP017",
                   "name":  "Quinara Ledger Desk",
                   "category":  "Document Management"
               },
    "APP018":  {
                   "id":  "APP018",
                   "name":  "Roveni Report Hub",
                   "category":  "Document Management"
               },
    "APP019":  {
                   "id":  "APP019",
                   "name":  "Selvex Document Vault",
                   "category":  "Document Management"
               },
    "APP020":  {
                   "id":  "APP020",
                   "name":  "Toriva Service Queue",
                   "category":  "Document Management"
               },
    "APP021":  {
                   "id":  "APP021",
                   "name":  "Ulveno Case Board",
                   "category":  "Document Management"
               },
    "APP022":  {
                   "id":  "APP022",
                   "name":  "Verixa Payment Studio",
                   "category":  "Document Management"
               },
    "APP023":  {
                   "id":  "APP023",
                   "name":  "Welora Risk Monitor",
                   "category":  "Document Management"
               },
    "APP024":  {
                   "id":  "APP024",
                   "name":  "Xaveli Access Console",
                   "category":  "Document Management"
               },
    "APP025":  {
                   "id":  "APP025",
                   "name":  "Yorena Ledger Desk",
                   "category":  "Customer Servicing"
               },
    "APP026":  {
                   "id":  "APP026",
                   "name":  "Zelvian Report Hub",
                   "category":  "Customer Servicing"
               },
    "APP027":  {
                   "id":  "APP027",
                   "name":  "Arvexa Document Vault",
                   "category":  "Customer Servicing"
               },
    "APP028":  {
                   "id":  "APP028",
                   "name":  "Brenora Service Queue",
                   "category":  "Customer Servicing"
               },
    "APP029":  {
                   "id":  "APP029",
                   "name":  "Corvian Case Board",
                   "category":  "Customer Servicing"
               },
    "APP030":  {
                   "id":  "APP030",
                   "name":  "Delenix Payment Studio",
                   "category":  "Customer Servicing"
               },
    "APP031":  {
                   "id":  "APP031",
                   "name":  "Evaron Risk Monitor",
                   "category":  "Customer Servicing"
               },
    "APP032":  {
                   "id":  "APP032",
                   "name":  "Folvira Access Console",
                   "category":  "Customer Servicing"
               },
    "APP033":  {
                   "id":  "APP033",
                   "name":  "Gorena Ledger Desk",
                   "category":  "Case Management"
               },
    "APP034":  {
                   "id":  "APP034",
                   "name":  "Helvian Report Hub",
                   "category":  "Case Management"
               },
    "APP035":  {
                   "id":  "APP035",
                   "name":  "Ilenor Document Vault",
                   "category":  "Case Management"
               },
    "APP036":  {
                   "id":  "APP036",
                   "name":  "Jovexa Service Queue",
                   "category":  "Case Management"
               },
    "APP037":  {
                   "id":  "APP037",
                   "name":  "Kavira Case Board",
                   "category":  "Case Management"
               },
    "APP038":  {
                   "id":  "APP038",
                   "name":  "Lerovo Payment Studio",
                   "category":  "Case Management"
               },
    "APP039":  {
                   "id":  "APP039",
                   "name":  "Morvian Risk Monitor",
                   "category":  "Case Management"
               },
    "APP040":  {
                   "id":  "APP040",
                   "name":  "Nuvexa Access Console",
                   "category":  "Case Management"
               }
};

export const BASELINE_ENTITLEMENTS = {
    "ENT0001":  {
                    "entitlementId":  "ENT0001",
                    "name":  "Read Desk (APP001)",
                    "displayName":  "Read Desk",
                    "appId":  "APP001",
                    "appName":  "Avenra Ledger Desk",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP001-ENT0001",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Avenra Ledger Desk"
                                     ],
                    "description":  "Read Desk permission within Avenra Ledger Desk (APP001)."
                },
    "ENT0002":  {
                    "entitlementId":  "ENT0002",
                    "name":  "Work Queue (APP001)",
                    "displayName":  "Work Queue",
                    "appId":  "APP001",
                    "appName":  "Avenra Ledger Desk",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP001-ENT0002",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Avenra Ledger Desk"
                                     ],
                    "description":  "Work Queue permission within Avenra Ledger Desk (APP001)."
                },
    "ENT0003":  {
                    "entitlementId":  "ENT0003",
                    "name":  "Case Review (APP001)",
                    "displayName":  "Case Review",
                    "appId":  "APP001",
                    "appName":  "Avenra Ledger Desk",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP001-ENT0003",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Avenra Ledger Desk"
                                     ],
                    "description":  "Case Review permission within Avenra Ledger Desk (APP001)."
                },
    "ENT0004":  {
                    "entitlementId":  "ENT0004",
                    "name":  "Report Export (APP001)",
                    "displayName":  "Report Export",
                    "appId":  "APP001",
                    "appName":  "Avenra Ledger Desk",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP001-ENT0004",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Avenra Ledger Desk"
                                     ],
                    "description":  "Report Export permission within Avenra Ledger Desk (APP001)."
                },
    "ENT0005":  {
                    "entitlementId":  "ENT0005",
                    "name":  "Exception Review (APP001)",
                    "displayName":  "Exception Review",
                    "appId":  "APP001",
                    "appName":  "Avenra Ledger Desk",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP001-ENT0005",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Avenra Ledger Desk"
                                     ],
                    "description":  "Exception Review permission within Avenra Ledger Desk (APP001)."
                },
    "ENT0006":  {
                    "entitlementId":  "ENT0006",
                    "name":  "Batch Control (APP001)",
                    "displayName":  "Batch Control",
                    "appId":  "APP001",
                    "appName":  "Avenra Ledger Desk",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP001-ENT0006",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Avenra Ledger Desk"
                                     ],
                    "description":  "Batch Control permission within Avenra Ledger Desk (APP001)."
                },
    "ENT0007":  {
                    "entitlementId":  "ENT0007",
                    "name":  "Access Steward (APP001)",
                    "displayName":  "Access Steward",
                    "appId":  "APP001",
                    "appName":  "Avenra Ledger Desk",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP001-ENT0007",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Administrative",
                    "applications":  [
                                         "Avenra Ledger Desk"
                                     ],
                    "description":  "Access Steward permission within Avenra Ledger Desk (APP001)."
                },
    "ENT0008":  {
                    "entitlementId":  "ENT0008",
                    "name":  "Read Desk (APP002)",
                    "displayName":  "Read Desk",
                    "appId":  "APP002",
                    "appName":  "Belyx Report Hub",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP002-ENT0008",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Belyx Report Hub"
                                     ],
                    "description":  "Read Desk permission within Belyx Report Hub (APP002)."
                },
    "ENT0009":  {
                    "entitlementId":  "ENT0009",
                    "name":  "Work Queue (APP002)",
                    "displayName":  "Work Queue",
                    "appId":  "APP002",
                    "appName":  "Belyx Report Hub",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP002-ENT0009",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Belyx Report Hub"
                                     ],
                    "description":  "Work Queue permission within Belyx Report Hub (APP002)."
                },
    "ENT0010":  {
                    "entitlementId":  "ENT0010",
                    "name":  "Case Review (APP002)",
                    "displayName":  "Case Review",
                    "appId":  "APP002",
                    "appName":  "Belyx Report Hub",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP002-ENT0010",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Belyx Report Hub"
                                     ],
                    "description":  "Case Review permission within Belyx Report Hub (APP002)."
                },
    "ENT0011":  {
                    "entitlementId":  "ENT0011",
                    "name":  "Report Export (APP002)",
                    "displayName":  "Report Export",
                    "appId":  "APP002",
                    "appName":  "Belyx Report Hub",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP002-ENT0011",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Belyx Report Hub"
                                     ],
                    "description":  "Report Export permission within Belyx Report Hub (APP002)."
                },
    "ENT0012":  {
                    "entitlementId":  "ENT0012",
                    "name":  "Exception Review (APP002)",
                    "displayName":  "Exception Review",
                    "appId":  "APP002",
                    "appName":  "Belyx Report Hub",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP002-ENT0012",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Belyx Report Hub"
                                     ],
                    "description":  "Exception Review permission within Belyx Report Hub (APP002)."
                },
    "ENT0013":  {
                    "entitlementId":  "ENT0013",
                    "name":  "Batch Control (APP002)",
                    "displayName":  "Batch Control",
                    "appId":  "APP002",
                    "appName":  "Belyx Report Hub",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP002-ENT0013",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Belyx Report Hub"
                                     ],
                    "description":  "Batch Control permission within Belyx Report Hub (APP002)."
                },
    "ENT0014":  {
                    "entitlementId":  "ENT0014",
                    "name":  "Access Steward (APP002)",
                    "displayName":  "Access Steward",
                    "appId":  "APP002",
                    "appName":  "Belyx Report Hub",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP002-ENT0014",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Administrative",
                    "applications":  [
                                         "Belyx Report Hub"
                                     ],
                    "description":  "Access Steward permission within Belyx Report Hub (APP002)."
                },
    "ENT0015":  {
                    "entitlementId":  "ENT0015",
                    "name":  "Read Desk (APP003)",
                    "displayName":  "Read Desk",
                    "appId":  "APP003",
                    "appName":  "Calora Document Vault",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP003-ENT0015",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Calora Document Vault"
                                     ],
                    "description":  "Read Desk permission within Calora Document Vault (APP003)."
                },
    "ENT0016":  {
                    "entitlementId":  "ENT0016",
                    "name":  "Work Queue (APP003)",
                    "displayName":  "Work Queue",
                    "appId":  "APP003",
                    "appName":  "Calora Document Vault",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP003-ENT0016",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Calora Document Vault"
                                     ],
                    "description":  "Work Queue permission within Calora Document Vault (APP003)."
                },
    "ENT0017":  {
                    "entitlementId":  "ENT0017",
                    "name":  "Case Review (APP003)",
                    "displayName":  "Case Review",
                    "appId":  "APP003",
                    "appName":  "Calora Document Vault",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP003-ENT0017",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Calora Document Vault"
                                     ],
                    "description":  "Case Review permission within Calora Document Vault (APP003)."
                },
    "ENT0018":  {
                    "entitlementId":  "ENT0018",
                    "name":  "Report Export (APP003)",
                    "displayName":  "Report Export",
                    "appId":  "APP003",
                    "appName":  "Calora Document Vault",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP003-ENT0018",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Calora Document Vault"
                                     ],
                    "description":  "Report Export permission within Calora Document Vault (APP003)."
                },
    "ENT0019":  {
                    "entitlementId":  "ENT0019",
                    "name":  "Exception Review (APP003)",
                    "displayName":  "Exception Review",
                    "appId":  "APP003",
                    "appName":  "Calora Document Vault",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP003-ENT0019",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Calora Document Vault"
                                     ],
                    "description":  "Exception Review permission within Calora Document Vault (APP003)."
                },
    "ENT0020":  {
                    "entitlementId":  "ENT0020",
                    "name":  "Batch Control (APP003)",
                    "displayName":  "Batch Control",
                    "appId":  "APP003",
                    "appName":  "Calora Document Vault",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP003-ENT0020",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Calora Document Vault"
                                     ],
                    "description":  "Batch Control permission within Calora Document Vault (APP003)."
                },
    "ENT0021":  {
                    "entitlementId":  "ENT0021",
                    "name":  "Access Steward (APP003)",
                    "displayName":  "Access Steward",
                    "appId":  "APP003",
                    "appName":  "Calora Document Vault",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP003-ENT0021",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Administrative",
                    "applications":  [
                                         "Calora Document Vault"
                                     ],
                    "description":  "Access Steward permission within Calora Document Vault (APP003)."
                },
    "ENT0022":  {
                    "entitlementId":  "ENT0022",
                    "name":  "Read Desk (APP004)",
                    "displayName":  "Read Desk",
                    "appId":  "APP004",
                    "appName":  "Dovari Service Queue",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP004-ENT0022",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Dovari Service Queue"
                                     ],
                    "description":  "Read Desk permission within Dovari Service Queue (APP004)."
                },
    "ENT0023":  {
                    "entitlementId":  "ENT0023",
                    "name":  "Work Queue (APP004)",
                    "displayName":  "Work Queue",
                    "appId":  "APP004",
                    "appName":  "Dovari Service Queue",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP004-ENT0023",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Dovari Service Queue"
                                     ],
                    "description":  "Work Queue permission within Dovari Service Queue (APP004)."
                },
    "ENT0024":  {
                    "entitlementId":  "ENT0024",
                    "name":  "Case Review (APP004)",
                    "displayName":  "Case Review",
                    "appId":  "APP004",
                    "appName":  "Dovari Service Queue",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP004-ENT0024",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Dovari Service Queue"
                                     ],
                    "description":  "Case Review permission within Dovari Service Queue (APP004)."
                },
    "ENT0025":  {
                    "entitlementId":  "ENT0025",
                    "name":  "Report Export (APP004)",
                    "displayName":  "Report Export",
                    "appId":  "APP004",
                    "appName":  "Dovari Service Queue",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP004-ENT0025",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Dovari Service Queue"
                                     ],
                    "description":  "Report Export permission within Dovari Service Queue (APP004)."
                },
    "ENT0026":  {
                    "entitlementId":  "ENT0026",
                    "name":  "Exception Review (APP004)",
                    "displayName":  "Exception Review",
                    "appId":  "APP004",
                    "appName":  "Dovari Service Queue",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP004-ENT0026",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Dovari Service Queue"
                                     ],
                    "description":  "Exception Review permission within Dovari Service Queue (APP004)."
                },
    "ENT0027":  {
                    "entitlementId":  "ENT0027",
                    "name":  "Batch Control (APP004)",
                    "displayName":  "Batch Control",
                    "appId":  "APP004",
                    "appName":  "Dovari Service Queue",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP004-ENT0027",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Dovari Service Queue"
                                     ],
                    "description":  "Batch Control permission within Dovari Service Queue (APP004)."
                },
    "ENT0028":  {
                    "entitlementId":  "ENT0028",
                    "name":  "Access Steward (APP004)",
                    "displayName":  "Access Steward",
                    "appId":  "APP004",
                    "appName":  "Dovari Service Queue",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP004-ENT0028",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Administrative",
                    "applications":  [
                                         "Dovari Service Queue"
                                     ],
                    "description":  "Access Steward permission within Dovari Service Queue (APP004)."
                },
    "ENT0029":  {
                    "entitlementId":  "ENT0029",
                    "name":  "Read Desk (APP005)",
                    "displayName":  "Read Desk",
                    "appId":  "APP005",
                    "appName":  "Elenix Case Board",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP005-ENT0029",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Elenix Case Board"
                                     ],
                    "description":  "Read Desk permission within Elenix Case Board (APP005)."
                },
    "ENT0030":  {
                    "entitlementId":  "ENT0030",
                    "name":  "Work Queue (APP005)",
                    "displayName":  "Work Queue",
                    "appId":  "APP005",
                    "appName":  "Elenix Case Board",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP005-ENT0030",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Elenix Case Board"
                                     ],
                    "description":  "Work Queue permission within Elenix Case Board (APP005)."
                },
    "ENT0031":  {
                    "entitlementId":  "ENT0031",
                    "name":  "Case Review (APP005)",
                    "displayName":  "Case Review",
                    "appId":  "APP005",
                    "appName":  "Elenix Case Board",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP005-ENT0031",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Elenix Case Board"
                                     ],
                    "description":  "Case Review permission within Elenix Case Board (APP005)."
                },
    "ENT0032":  {
                    "entitlementId":  "ENT0032",
                    "name":  "Report Export (APP005)",
                    "displayName":  "Report Export",
                    "appId":  "APP005",
                    "appName":  "Elenix Case Board",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP005-ENT0032",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Elenix Case Board"
                                     ],
                    "description":  "Report Export permission within Elenix Case Board (APP005)."
                },
    "ENT0033":  {
                    "entitlementId":  "ENT0033",
                    "name":  "Exception Review (APP005)",
                    "displayName":  "Exception Review",
                    "appId":  "APP005",
                    "appName":  "Elenix Case Board",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP005-ENT0033",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Elenix Case Board"
                                     ],
                    "description":  "Exception Review permission within Elenix Case Board (APP005)."
                },
    "ENT0034":  {
                    "entitlementId":  "ENT0034",
                    "name":  "Batch Control (APP005)",
                    "displayName":  "Batch Control",
                    "appId":  "APP005",
                    "appName":  "Elenix Case Board",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP005-ENT0034",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Elenix Case Board"
                                     ],
                    "description":  "Batch Control permission within Elenix Case Board (APP005)."
                },
    "ENT0035":  {
                    "entitlementId":  "ENT0035",
                    "name":  "Access Steward (APP005)",
                    "displayName":  "Access Steward",
                    "appId":  "APP005",
                    "appName":  "Elenix Case Board",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP005-ENT0035",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Elenix Case Board"
                                     ],
                    "description":  "Access Steward permission within Elenix Case Board (APP005)."
                },
    "ENT0036":  {
                    "entitlementId":  "ENT0036",
                    "name":  "Read Desk (APP006)",
                    "displayName":  "Read Desk",
                    "appId":  "APP006",
                    "appName":  "Fentara Payment Studio",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP006-ENT0036",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Fentara Payment Studio"
                                     ],
                    "description":  "Read Desk permission within Fentara Payment Studio (APP006)."
                },
    "ENT0037":  {
                    "entitlementId":  "ENT0037",
                    "name":  "Work Queue (APP006)",
                    "displayName":  "Work Queue",
                    "appId":  "APP006",
                    "appName":  "Fentara Payment Studio",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP006-ENT0037",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Fentara Payment Studio"
                                     ],
                    "description":  "Work Queue permission within Fentara Payment Studio (APP006)."
                },
    "ENT0038":  {
                    "entitlementId":  "ENT0038",
                    "name":  "Case Review (APP006)",
                    "displayName":  "Case Review",
                    "appId":  "APP006",
                    "appName":  "Fentara Payment Studio",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP006-ENT0038",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Fentara Payment Studio"
                                     ],
                    "description":  "Case Review permission within Fentara Payment Studio (APP006)."
                },
    "ENT0039":  {
                    "entitlementId":  "ENT0039",
                    "name":  "Report Export (APP006)",
                    "displayName":  "Report Export",
                    "appId":  "APP006",
                    "appName":  "Fentara Payment Studio",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP006-ENT0039",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Fentara Payment Studio"
                                     ],
                    "description":  "Report Export permission within Fentara Payment Studio (APP006)."
                },
    "ENT0040":  {
                    "entitlementId":  "ENT0040",
                    "name":  "Exception Review (APP006)",
                    "displayName":  "Exception Review",
                    "appId":  "APP006",
                    "appName":  "Fentara Payment Studio",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP006-ENT0040",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Fentara Payment Studio"
                                     ],
                    "description":  "Exception Review permission within Fentara Payment Studio (APP006)."
                },
    "ENT0041":  {
                    "entitlementId":  "ENT0041",
                    "name":  "Batch Control (APP006)",
                    "displayName":  "Batch Control",
                    "appId":  "APP006",
                    "appName":  "Fentara Payment Studio",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP006-ENT0041",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Fentara Payment Studio"
                                     ],
                    "description":  "Batch Control permission within Fentara Payment Studio (APP006)."
                },
    "ENT0042":  {
                    "entitlementId":  "ENT0042",
                    "name":  "Access Steward (APP006)",
                    "displayName":  "Access Steward",
                    "appId":  "APP006",
                    "appName":  "Fentara Payment Studio",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP006-ENT0042",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Fentara Payment Studio"
                                     ],
                    "description":  "Access Steward permission within Fentara Payment Studio (APP006)."
                },
    "ENT0043":  {
                    "entitlementId":  "ENT0043",
                    "name":  "Read Desk (APP007)",
                    "displayName":  "Read Desk",
                    "appId":  "APP007",
                    "appName":  "Gavelo Risk Monitor",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP007-ENT0043",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Gavelo Risk Monitor"
                                     ],
                    "description":  "Read Desk permission within Gavelo Risk Monitor (APP007)."
                },
    "ENT0044":  {
                    "entitlementId":  "ENT0044",
                    "name":  "Work Queue (APP007)",
                    "displayName":  "Work Queue",
                    "appId":  "APP007",
                    "appName":  "Gavelo Risk Monitor",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP007-ENT0044",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Gavelo Risk Monitor"
                                     ],
                    "description":  "Work Queue permission within Gavelo Risk Monitor (APP007)."
                },
    "ENT0045":  {
                    "entitlementId":  "ENT0045",
                    "name":  "Case Review (APP007)",
                    "displayName":  "Case Review",
                    "appId":  "APP007",
                    "appName":  "Gavelo Risk Monitor",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP007-ENT0045",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Gavelo Risk Monitor"
                                     ],
                    "description":  "Case Review permission within Gavelo Risk Monitor (APP007)."
                },
    "ENT0046":  {
                    "entitlementId":  "ENT0046",
                    "name":  "Report Export (APP007)",
                    "displayName":  "Report Export",
                    "appId":  "APP007",
                    "appName":  "Gavelo Risk Monitor",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP007-ENT0046",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Gavelo Risk Monitor"
                                     ],
                    "description":  "Report Export permission within Gavelo Risk Monitor (APP007)."
                },
    "ENT0047":  {
                    "entitlementId":  "ENT0047",
                    "name":  "Exception Review (APP007)",
                    "displayName":  "Exception Review",
                    "appId":  "APP007",
                    "appName":  "Gavelo Risk Monitor",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP007-ENT0047",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Gavelo Risk Monitor"
                                     ],
                    "description":  "Exception Review permission within Gavelo Risk Monitor (APP007)."
                },
    "ENT0048":  {
                    "entitlementId":  "ENT0048",
                    "name":  "Batch Control (APP007)",
                    "displayName":  "Batch Control",
                    "appId":  "APP007",
                    "appName":  "Gavelo Risk Monitor",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP007-ENT0048",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Gavelo Risk Monitor"
                                     ],
                    "description":  "Batch Control permission within Gavelo Risk Monitor (APP007)."
                },
    "ENT0049":  {
                    "entitlementId":  "ENT0049",
                    "name":  "Access Steward (APP007)",
                    "displayName":  "Access Steward",
                    "appId":  "APP007",
                    "appName":  "Gavelo Risk Monitor",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP007-ENT0049",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Gavelo Risk Monitor"
                                     ],
                    "description":  "Access Steward permission within Gavelo Risk Monitor (APP007)."
                },
    "ENT0050":  {
                    "entitlementId":  "ENT0050",
                    "name":  "Read Desk (APP008)",
                    "displayName":  "Read Desk",
                    "appId":  "APP008",
                    "appName":  "Havora Access Console",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP008-ENT0050",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Havora Access Console"
                                     ],
                    "description":  "Read Desk permission within Havora Access Console (APP008)."
                },
    "ENT0051":  {
                    "entitlementId":  "ENT0051",
                    "name":  "Work Queue (APP008)",
                    "displayName":  "Work Queue",
                    "appId":  "APP008",
                    "appName":  "Havora Access Console",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP008-ENT0051",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Havora Access Console"
                                     ],
                    "description":  "Work Queue permission within Havora Access Console (APP008)."
                },
    "ENT0052":  {
                    "entitlementId":  "ENT0052",
                    "name":  "Case Review (APP008)",
                    "displayName":  "Case Review",
                    "appId":  "APP008",
                    "appName":  "Havora Access Console",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP008-ENT0052",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Havora Access Console"
                                     ],
                    "description":  "Case Review permission within Havora Access Console (APP008)."
                },
    "ENT0053":  {
                    "entitlementId":  "ENT0053",
                    "name":  "Report Export (APP008)",
                    "displayName":  "Report Export",
                    "appId":  "APP008",
                    "appName":  "Havora Access Console",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP008-ENT0053",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Havora Access Console"
                                     ],
                    "description":  "Report Export permission within Havora Access Console (APP008)."
                },
    "ENT0054":  {
                    "entitlementId":  "ENT0054",
                    "name":  "Exception Review (APP008)",
                    "displayName":  "Exception Review",
                    "appId":  "APP008",
                    "appName":  "Havora Access Console",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP008-ENT0054",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Havora Access Console"
                                     ],
                    "description":  "Exception Review permission within Havora Access Console (APP008)."
                },
    "ENT0055":  {
                    "entitlementId":  "ENT0055",
                    "name":  "Batch Control (APP008)",
                    "displayName":  "Batch Control",
                    "appId":  "APP008",
                    "appName":  "Havora Access Console",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP008-ENT0055",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Havora Access Console"
                                     ],
                    "description":  "Batch Control permission within Havora Access Console (APP008)."
                },
    "ENT0056":  {
                    "entitlementId":  "ENT0056",
                    "name":  "Access Steward (APP008)",
                    "displayName":  "Access Steward",
                    "appId":  "APP008",
                    "appName":  "Havora Access Console",
                    "appCategory":  "Finance Operations",
                    "adGroup":  "SG-APP008-ENT0056",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Havora Access Console"
                                     ],
                    "description":  "Access Steward permission within Havora Access Console (APP008)."
                },
    "ENT0057":  {
                    "entitlementId":  "ENT0057",
                    "name":  "Read Desk (APP009)",
                    "displayName":  "Read Desk",
                    "appId":  "APP009",
                    "appName":  "Iverna Ledger Desk",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP009-ENT0057",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Iverna Ledger Desk"
                                     ],
                    "description":  "Read Desk permission within Iverna Ledger Desk (APP009)."
                },
    "ENT0058":  {
                    "entitlementId":  "ENT0058",
                    "name":  "Work Queue (APP009)",
                    "displayName":  "Work Queue",
                    "appId":  "APP009",
                    "appName":  "Iverna Ledger Desk",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP009-ENT0058",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Iverna Ledger Desk"
                                     ],
                    "description":  "Work Queue permission within Iverna Ledger Desk (APP009)."
                },
    "ENT0059":  {
                    "entitlementId":  "ENT0059",
                    "name":  "Case Review (APP009)",
                    "displayName":  "Case Review",
                    "appId":  "APP009",
                    "appName":  "Iverna Ledger Desk",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP009-ENT0059",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Iverna Ledger Desk"
                                     ],
                    "description":  "Case Review permission within Iverna Ledger Desk (APP009)."
                },
    "ENT0060":  {
                    "entitlementId":  "ENT0060",
                    "name":  "Report Export (APP009)",
                    "displayName":  "Report Export",
                    "appId":  "APP009",
                    "appName":  "Iverna Ledger Desk",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP009-ENT0060",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Iverna Ledger Desk"
                                     ],
                    "description":  "Report Export permission within Iverna Ledger Desk (APP009)."
                },
    "ENT0061":  {
                    "entitlementId":  "ENT0061",
                    "name":  "Exception Review (APP009)",
                    "displayName":  "Exception Review",
                    "appId":  "APP009",
                    "appName":  "Iverna Ledger Desk",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP009-ENT0061",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Iverna Ledger Desk"
                                     ],
                    "description":  "Exception Review permission within Iverna Ledger Desk (APP009)."
                },
    "ENT0062":  {
                    "entitlementId":  "ENT0062",
                    "name":  "Batch Control (APP009)",
                    "displayName":  "Batch Control",
                    "appId":  "APP009",
                    "appName":  "Iverna Ledger Desk",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP009-ENT0062",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Iverna Ledger Desk"
                                     ],
                    "description":  "Batch Control permission within Iverna Ledger Desk (APP009)."
                },
    "ENT0063":  {
                    "entitlementId":  "ENT0063",
                    "name":  "Access Steward (APP009)",
                    "displayName":  "Access Steward",
                    "appId":  "APP009",
                    "appName":  "Iverna Ledger Desk",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP009-ENT0063",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Iverna Ledger Desk"
                                     ],
                    "description":  "Access Steward permission within Iverna Ledger Desk (APP009)."
                },
    "ENT0064":  {
                    "entitlementId":  "ENT0064",
                    "name":  "Read Desk (APP010)",
                    "displayName":  "Read Desk",
                    "appId":  "APP010",
                    "appName":  "Jalven Report Hub",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP010-ENT0064",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Jalven Report Hub"
                                     ],
                    "description":  "Read Desk permission within Jalven Report Hub (APP010)."
                },
    "ENT0065":  {
                    "entitlementId":  "ENT0065",
                    "name":  "Work Queue (APP010)",
                    "displayName":  "Work Queue",
                    "appId":  "APP010",
                    "appName":  "Jalven Report Hub",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP010-ENT0065",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Jalven Report Hub"
                                     ],
                    "description":  "Work Queue permission within Jalven Report Hub (APP010)."
                },
    "ENT0066":  {
                    "entitlementId":  "ENT0066",
                    "name":  "Case Review (APP010)",
                    "displayName":  "Case Review",
                    "appId":  "APP010",
                    "appName":  "Jalven Report Hub",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP010-ENT0066",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Jalven Report Hub"
                                     ],
                    "description":  "Case Review permission within Jalven Report Hub (APP010)."
                },
    "ENT0067":  {
                    "entitlementId":  "ENT0067",
                    "name":  "Report Export (APP010)",
                    "displayName":  "Report Export",
                    "appId":  "APP010",
                    "appName":  "Jalven Report Hub",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP010-ENT0067",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Jalven Report Hub"
                                     ],
                    "description":  "Report Export permission within Jalven Report Hub (APP010)."
                },
    "ENT0068":  {
                    "entitlementId":  "ENT0068",
                    "name":  "Exception Review (APP010)",
                    "displayName":  "Exception Review",
                    "appId":  "APP010",
                    "appName":  "Jalven Report Hub",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP010-ENT0068",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Jalven Report Hub"
                                     ],
                    "description":  "Exception Review permission within Jalven Report Hub (APP010)."
                },
    "ENT0069":  {
                    "entitlementId":  "ENT0069",
                    "name":  "Batch Control (APP010)",
                    "displayName":  "Batch Control",
                    "appId":  "APP010",
                    "appName":  "Jalven Report Hub",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP010-ENT0069",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Jalven Report Hub"
                                     ],
                    "description":  "Batch Control permission within Jalven Report Hub (APP010)."
                },
    "ENT0070":  {
                    "entitlementId":  "ENT0070",
                    "name":  "Access Steward (APP010)",
                    "displayName":  "Access Steward",
                    "appId":  "APP010",
                    "appName":  "Jalven Report Hub",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP010-ENT0070",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Jalven Report Hub"
                                     ],
                    "description":  "Access Steward permission within Jalven Report Hub (APP010)."
                },
    "ENT0071":  {
                    "entitlementId":  "ENT0071",
                    "name":  "Read Desk (APP011)",
                    "displayName":  "Read Desk",
                    "appId":  "APP011",
                    "appName":  "Korevi Document Vault",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP011-ENT0071",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Korevi Document Vault"
                                     ],
                    "description":  "Read Desk permission within Korevi Document Vault (APP011)."
                },
    "ENT0072":  {
                    "entitlementId":  "ENT0072",
                    "name":  "Work Queue (APP011)",
                    "displayName":  "Work Queue",
                    "appId":  "APP011",
                    "appName":  "Korevi Document Vault",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP011-ENT0072",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Korevi Document Vault"
                                     ],
                    "description":  "Work Queue permission within Korevi Document Vault (APP011)."
                },
    "ENT0073":  {
                    "entitlementId":  "ENT0073",
                    "name":  "Case Review (APP011)",
                    "displayName":  "Case Review",
                    "appId":  "APP011",
                    "appName":  "Korevi Document Vault",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP011-ENT0073",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Korevi Document Vault"
                                     ],
                    "description":  "Case Review permission within Korevi Document Vault (APP011)."
                },
    "ENT0074":  {
                    "entitlementId":  "ENT0074",
                    "name":  "Report Export (APP011)",
                    "displayName":  "Report Export",
                    "appId":  "APP011",
                    "appName":  "Korevi Document Vault",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP011-ENT0074",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Korevi Document Vault"
                                     ],
                    "description":  "Report Export permission within Korevi Document Vault (APP011)."
                },
    "ENT0075":  {
                    "entitlementId":  "ENT0075",
                    "name":  "Exception Review (APP011)",
                    "displayName":  "Exception Review",
                    "appId":  "APP011",
                    "appName":  "Korevi Document Vault",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP011-ENT0075",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Korevi Document Vault"
                                     ],
                    "description":  "Exception Review permission within Korevi Document Vault (APP011)."
                },
    "ENT0076":  {
                    "entitlementId":  "ENT0076",
                    "name":  "Batch Control (APP011)",
                    "displayName":  "Batch Control",
                    "appId":  "APP011",
                    "appName":  "Korevi Document Vault",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP011-ENT0076",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Korevi Document Vault"
                                     ],
                    "description":  "Batch Control permission within Korevi Document Vault (APP011)."
                },
    "ENT0077":  {
                    "entitlementId":  "ENT0077",
                    "name":  "Read Desk (APP012)",
                    "displayName":  "Read Desk",
                    "appId":  "APP012",
                    "appName":  "Lunaro Service Queue",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP012-ENT0077",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Lunaro Service Queue"
                                     ],
                    "description":  "Read Desk permission within Lunaro Service Queue (APP012)."
                },
    "ENT0078":  {
                    "entitlementId":  "ENT0078",
                    "name":  "Work Queue (APP012)",
                    "displayName":  "Work Queue",
                    "appId":  "APP012",
                    "appName":  "Lunaro Service Queue",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP012-ENT0078",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Lunaro Service Queue"
                                     ],
                    "description":  "Work Queue permission within Lunaro Service Queue (APP012)."
                },
    "ENT0079":  {
                    "entitlementId":  "ENT0079",
                    "name":  "Case Review (APP012)",
                    "displayName":  "Case Review",
                    "appId":  "APP012",
                    "appName":  "Lunaro Service Queue",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP012-ENT0079",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Lunaro Service Queue"
                                     ],
                    "description":  "Case Review permission within Lunaro Service Queue (APP012)."
                },
    "ENT0080":  {
                    "entitlementId":  "ENT0080",
                    "name":  "Report Export (APP012)",
                    "displayName":  "Report Export",
                    "appId":  "APP012",
                    "appName":  "Lunaro Service Queue",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP012-ENT0080",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Lunaro Service Queue"
                                     ],
                    "description":  "Report Export permission within Lunaro Service Queue (APP012)."
                },
    "ENT0081":  {
                    "entitlementId":  "ENT0081",
                    "name":  "Exception Review (APP012)",
                    "displayName":  "Exception Review",
                    "appId":  "APP012",
                    "appName":  "Lunaro Service Queue",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP012-ENT0081",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Lunaro Service Queue"
                                     ],
                    "description":  "Exception Review permission within Lunaro Service Queue (APP012)."
                },
    "ENT0082":  {
                    "entitlementId":  "ENT0082",
                    "name":  "Batch Control (APP012)",
                    "displayName":  "Batch Control",
                    "appId":  "APP012",
                    "appName":  "Lunaro Service Queue",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP012-ENT0082",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Lunaro Service Queue"
                                     ],
                    "description":  "Batch Control permission within Lunaro Service Queue (APP012)."
                },
    "ENT0083":  {
                    "entitlementId":  "ENT0083",
                    "name":  "Read Desk (APP013)",
                    "displayName":  "Read Desk",
                    "appId":  "APP013",
                    "appName":  "Mavira Case Board",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP013-ENT0083",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Mavira Case Board"
                                     ],
                    "description":  "Read Desk permission within Mavira Case Board (APP013)."
                },
    "ENT0084":  {
                    "entitlementId":  "ENT0084",
                    "name":  "Work Queue (APP013)",
                    "displayName":  "Work Queue",
                    "appId":  "APP013",
                    "appName":  "Mavira Case Board",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP013-ENT0084",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Mavira Case Board"
                                     ],
                    "description":  "Work Queue permission within Mavira Case Board (APP013)."
                },
    "ENT0085":  {
                    "entitlementId":  "ENT0085",
                    "name":  "Case Review (APP013)",
                    "displayName":  "Case Review",
                    "appId":  "APP013",
                    "appName":  "Mavira Case Board",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP013-ENT0085",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Mavira Case Board"
                                     ],
                    "description":  "Case Review permission within Mavira Case Board (APP013)."
                },
    "ENT0086":  {
                    "entitlementId":  "ENT0086",
                    "name":  "Report Export (APP013)",
                    "displayName":  "Report Export",
                    "appId":  "APP013",
                    "appName":  "Mavira Case Board",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP013-ENT0086",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Mavira Case Board"
                                     ],
                    "description":  "Report Export permission within Mavira Case Board (APP013)."
                },
    "ENT0087":  {
                    "entitlementId":  "ENT0087",
                    "name":  "Exception Review (APP013)",
                    "displayName":  "Exception Review",
                    "appId":  "APP013",
                    "appName":  "Mavira Case Board",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP013-ENT0087",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Mavira Case Board"
                                     ],
                    "description":  "Exception Review permission within Mavira Case Board (APP013)."
                },
    "ENT0088":  {
                    "entitlementId":  "ENT0088",
                    "name":  "Batch Control (APP013)",
                    "displayName":  "Batch Control",
                    "appId":  "APP013",
                    "appName":  "Mavira Case Board",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP013-ENT0088",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Mavira Case Board"
                                     ],
                    "description":  "Batch Control permission within Mavira Case Board (APP013)."
                },
    "ENT0089":  {
                    "entitlementId":  "ENT0089",
                    "name":  "Read Desk (APP014)",
                    "displayName":  "Read Desk",
                    "appId":  "APP014",
                    "appName":  "Nerovo Payment Studio",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP014-ENT0089",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Nerovo Payment Studio"
                                     ],
                    "description":  "Read Desk permission within Nerovo Payment Studio (APP014)."
                },
    "ENT0090":  {
                    "entitlementId":  "ENT0090",
                    "name":  "Work Queue (APP014)",
                    "displayName":  "Work Queue",
                    "appId":  "APP014",
                    "appName":  "Nerovo Payment Studio",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP014-ENT0090",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Nerovo Payment Studio"
                                     ],
                    "description":  "Work Queue permission within Nerovo Payment Studio (APP014)."
                },
    "ENT0091":  {
                    "entitlementId":  "ENT0091",
                    "name":  "Case Review (APP014)",
                    "displayName":  "Case Review",
                    "appId":  "APP014",
                    "appName":  "Nerovo Payment Studio",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP014-ENT0091",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Nerovo Payment Studio"
                                     ],
                    "description":  "Case Review permission within Nerovo Payment Studio (APP014)."
                },
    "ENT0092":  {
                    "entitlementId":  "ENT0092",
                    "name":  "Report Export (APP014)",
                    "displayName":  "Report Export",
                    "appId":  "APP014",
                    "appName":  "Nerovo Payment Studio",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP014-ENT0092",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Nerovo Payment Studio"
                                     ],
                    "description":  "Report Export permission within Nerovo Payment Studio (APP014)."
                },
    "ENT0093":  {
                    "entitlementId":  "ENT0093",
                    "name":  "Exception Review (APP014)",
                    "displayName":  "Exception Review",
                    "appId":  "APP014",
                    "appName":  "Nerovo Payment Studio",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP014-ENT0093",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Nerovo Payment Studio"
                                     ],
                    "description":  "Exception Review permission within Nerovo Payment Studio (APP014)."
                },
    "ENT0094":  {
                    "entitlementId":  "ENT0094",
                    "name":  "Batch Control (APP014)",
                    "displayName":  "Batch Control",
                    "appId":  "APP014",
                    "appName":  "Nerovo Payment Studio",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP014-ENT0094",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Nerovo Payment Studio"
                                     ],
                    "description":  "Batch Control permission within Nerovo Payment Studio (APP014)."
                },
    "ENT0095":  {
                    "entitlementId":  "ENT0095",
                    "name":  "Read Desk (APP015)",
                    "displayName":  "Read Desk",
                    "appId":  "APP015",
                    "appName":  "Orvexa Risk Monitor",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP015-ENT0095",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Orvexa Risk Monitor"
                                     ],
                    "description":  "Read Desk permission within Orvexa Risk Monitor (APP015)."
                },
    "ENT0096":  {
                    "entitlementId":  "ENT0096",
                    "name":  "Work Queue (APP015)",
                    "displayName":  "Work Queue",
                    "appId":  "APP015",
                    "appName":  "Orvexa Risk Monitor",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP015-ENT0096",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Orvexa Risk Monitor"
                                     ],
                    "description":  "Work Queue permission within Orvexa Risk Monitor (APP015)."
                },
    "ENT0097":  {
                    "entitlementId":  "ENT0097",
                    "name":  "Case Review (APP015)",
                    "displayName":  "Case Review",
                    "appId":  "APP015",
                    "appName":  "Orvexa Risk Monitor",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP015-ENT0097",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Orvexa Risk Monitor"
                                     ],
                    "description":  "Case Review permission within Orvexa Risk Monitor (APP015)."
                },
    "ENT0098":  {
                    "entitlementId":  "ENT0098",
                    "name":  "Report Export (APP015)",
                    "displayName":  "Report Export",
                    "appId":  "APP015",
                    "appName":  "Orvexa Risk Monitor",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP015-ENT0098",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Orvexa Risk Monitor"
                                     ],
                    "description":  "Report Export permission within Orvexa Risk Monitor (APP015)."
                },
    "ENT0099":  {
                    "entitlementId":  "ENT0099",
                    "name":  "Exception Review (APP015)",
                    "displayName":  "Exception Review",
                    "appId":  "APP015",
                    "appName":  "Orvexa Risk Monitor",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP015-ENT0099",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Orvexa Risk Monitor"
                                     ],
                    "description":  "Exception Review permission within Orvexa Risk Monitor (APP015)."
                },
    "ENT0100":  {
                    "entitlementId":  "ENT0100",
                    "name":  "Batch Control (APP015)",
                    "displayName":  "Batch Control",
                    "appId":  "APP015",
                    "appName":  "Orvexa Risk Monitor",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP015-ENT0100",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Orvexa Risk Monitor"
                                     ],
                    "description":  "Batch Control permission within Orvexa Risk Monitor (APP015)."
                },
    "ENT0101":  {
                    "entitlementId":  "ENT0101",
                    "name":  "Read Desk (APP016)",
                    "displayName":  "Read Desk",
                    "appId":  "APP016",
                    "appName":  "Pavelo Access Console",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP016-ENT0101",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Pavelo Access Console"
                                     ],
                    "description":  "Read Desk permission within Pavelo Access Console (APP016)."
                },
    "ENT0102":  {
                    "entitlementId":  "ENT0102",
                    "name":  "Work Queue (APP016)",
                    "displayName":  "Work Queue",
                    "appId":  "APP016",
                    "appName":  "Pavelo Access Console",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP016-ENT0102",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Pavelo Access Console"
                                     ],
                    "description":  "Work Queue permission within Pavelo Access Console (APP016)."
                },
    "ENT0103":  {
                    "entitlementId":  "ENT0103",
                    "name":  "Case Review (APP016)",
                    "displayName":  "Case Review",
                    "appId":  "APP016",
                    "appName":  "Pavelo Access Console",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP016-ENT0103",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Pavelo Access Console"
                                     ],
                    "description":  "Case Review permission within Pavelo Access Console (APP016)."
                },
    "ENT0104":  {
                    "entitlementId":  "ENT0104",
                    "name":  "Report Export (APP016)",
                    "displayName":  "Report Export",
                    "appId":  "APP016",
                    "appName":  "Pavelo Access Console",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP016-ENT0104",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Pavelo Access Console"
                                     ],
                    "description":  "Report Export permission within Pavelo Access Console (APP016)."
                },
    "ENT0105":  {
                    "entitlementId":  "ENT0105",
                    "name":  "Exception Review (APP016)",
                    "displayName":  "Exception Review",
                    "appId":  "APP016",
                    "appName":  "Pavelo Access Console",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP016-ENT0105",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Pavelo Access Console"
                                     ],
                    "description":  "Exception Review permission within Pavelo Access Console (APP016)."
                },
    "ENT0106":  {
                    "entitlementId":  "ENT0106",
                    "name":  "Batch Control (APP016)",
                    "displayName":  "Batch Control",
                    "appId":  "APP016",
                    "appName":  "Pavelo Access Console",
                    "appCategory":  "Reporting",
                    "adGroup":  "SG-APP016-ENT0106",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Pavelo Access Console"
                                     ],
                    "description":  "Batch Control permission within Pavelo Access Console (APP016)."
                },
    "ENT0107":  {
                    "entitlementId":  "ENT0107",
                    "name":  "Read Desk (APP017)",
                    "displayName":  "Read Desk",
                    "appId":  "APP017",
                    "appName":  "Quinara Ledger Desk",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP017-ENT0107",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Quinara Ledger Desk"
                                     ],
                    "description":  "Read Desk permission within Quinara Ledger Desk (APP017)."
                },
    "ENT0108":  {
                    "entitlementId":  "ENT0108",
                    "name":  "Work Queue (APP017)",
                    "displayName":  "Work Queue",
                    "appId":  "APP017",
                    "appName":  "Quinara Ledger Desk",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP017-ENT0108",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Quinara Ledger Desk"
                                     ],
                    "description":  "Work Queue permission within Quinara Ledger Desk (APP017)."
                },
    "ENT0109":  {
                    "entitlementId":  "ENT0109",
                    "name":  "Case Review (APP017)",
                    "displayName":  "Case Review",
                    "appId":  "APP017",
                    "appName":  "Quinara Ledger Desk",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP017-ENT0109",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Quinara Ledger Desk"
                                     ],
                    "description":  "Case Review permission within Quinara Ledger Desk (APP017)."
                },
    "ENT0110":  {
                    "entitlementId":  "ENT0110",
                    "name":  "Report Export (APP017)",
                    "displayName":  "Report Export",
                    "appId":  "APP017",
                    "appName":  "Quinara Ledger Desk",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP017-ENT0110",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Quinara Ledger Desk"
                                     ],
                    "description":  "Report Export permission within Quinara Ledger Desk (APP017)."
                },
    "ENT0111":  {
                    "entitlementId":  "ENT0111",
                    "name":  "Exception Review (APP017)",
                    "displayName":  "Exception Review",
                    "appId":  "APP017",
                    "appName":  "Quinara Ledger Desk",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP017-ENT0111",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Quinara Ledger Desk"
                                     ],
                    "description":  "Exception Review permission within Quinara Ledger Desk (APP017)."
                },
    "ENT0112":  {
                    "entitlementId":  "ENT0112",
                    "name":  "Batch Control (APP017)",
                    "displayName":  "Batch Control",
                    "appId":  "APP017",
                    "appName":  "Quinara Ledger Desk",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP017-ENT0112",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Quinara Ledger Desk"
                                     ],
                    "description":  "Batch Control permission within Quinara Ledger Desk (APP017)."
                },
    "ENT0113":  {
                    "entitlementId":  "ENT0113",
                    "name":  "Read Desk (APP018)",
                    "displayName":  "Read Desk",
                    "appId":  "APP018",
                    "appName":  "Roveni Report Hub",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP018-ENT0113",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Roveni Report Hub"
                                     ],
                    "description":  "Read Desk permission within Roveni Report Hub (APP018)."
                },
    "ENT0114":  {
                    "entitlementId":  "ENT0114",
                    "name":  "Work Queue (APP018)",
                    "displayName":  "Work Queue",
                    "appId":  "APP018",
                    "appName":  "Roveni Report Hub",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP018-ENT0114",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Roveni Report Hub"
                                     ],
                    "description":  "Work Queue permission within Roveni Report Hub (APP018)."
                },
    "ENT0115":  {
                    "entitlementId":  "ENT0115",
                    "name":  "Case Review (APP018)",
                    "displayName":  "Case Review",
                    "appId":  "APP018",
                    "appName":  "Roveni Report Hub",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP018-ENT0115",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Roveni Report Hub"
                                     ],
                    "description":  "Case Review permission within Roveni Report Hub (APP018)."
                },
    "ENT0116":  {
                    "entitlementId":  "ENT0116",
                    "name":  "Report Export (APP018)",
                    "displayName":  "Report Export",
                    "appId":  "APP018",
                    "appName":  "Roveni Report Hub",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP018-ENT0116",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Roveni Report Hub"
                                     ],
                    "description":  "Report Export permission within Roveni Report Hub (APP018)."
                },
    "ENT0117":  {
                    "entitlementId":  "ENT0117",
                    "name":  "Exception Review (APP018)",
                    "displayName":  "Exception Review",
                    "appId":  "APP018",
                    "appName":  "Roveni Report Hub",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP018-ENT0117",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Roveni Report Hub"
                                     ],
                    "description":  "Exception Review permission within Roveni Report Hub (APP018)."
                },
    "ENT0118":  {
                    "entitlementId":  "ENT0118",
                    "name":  "Batch Control (APP018)",
                    "displayName":  "Batch Control",
                    "appId":  "APP018",
                    "appName":  "Roveni Report Hub",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP018-ENT0118",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Roveni Report Hub"
                                     ],
                    "description":  "Batch Control permission within Roveni Report Hub (APP018)."
                },
    "ENT0119":  {
                    "entitlementId":  "ENT0119",
                    "name":  "Read Desk (APP019)",
                    "displayName":  "Read Desk",
                    "appId":  "APP019",
                    "appName":  "Selvex Document Vault",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP019-ENT0119",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Selvex Document Vault"
                                     ],
                    "description":  "Read Desk permission within Selvex Document Vault (APP019)."
                },
    "ENT0120":  {
                    "entitlementId":  "ENT0120",
                    "name":  "Work Queue (APP019)",
                    "displayName":  "Work Queue",
                    "appId":  "APP019",
                    "appName":  "Selvex Document Vault",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP019-ENT0120",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Selvex Document Vault"
                                     ],
                    "description":  "Work Queue permission within Selvex Document Vault (APP019)."
                },
    "ENT0121":  {
                    "entitlementId":  "ENT0121",
                    "name":  "Case Review (APP019)",
                    "displayName":  "Case Review",
                    "appId":  "APP019",
                    "appName":  "Selvex Document Vault",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP019-ENT0121",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Selvex Document Vault"
                                     ],
                    "description":  "Case Review permission within Selvex Document Vault (APP019)."
                },
    "ENT0122":  {
                    "entitlementId":  "ENT0122",
                    "name":  "Report Export (APP019)",
                    "displayName":  "Report Export",
                    "appId":  "APP019",
                    "appName":  "Selvex Document Vault",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP019-ENT0122",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Selvex Document Vault"
                                     ],
                    "description":  "Report Export permission within Selvex Document Vault (APP019)."
                },
    "ENT0123":  {
                    "entitlementId":  "ENT0123",
                    "name":  "Exception Review (APP019)",
                    "displayName":  "Exception Review",
                    "appId":  "APP019",
                    "appName":  "Selvex Document Vault",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP019-ENT0123",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Selvex Document Vault"
                                     ],
                    "description":  "Exception Review permission within Selvex Document Vault (APP019)."
                },
    "ENT0124":  {
                    "entitlementId":  "ENT0124",
                    "name":  "Batch Control (APP019)",
                    "displayName":  "Batch Control",
                    "appId":  "APP019",
                    "appName":  "Selvex Document Vault",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP019-ENT0124",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Selvex Document Vault"
                                     ],
                    "description":  "Batch Control permission within Selvex Document Vault (APP019)."
                },
    "ENT0125":  {
                    "entitlementId":  "ENT0125",
                    "name":  "Read Desk (APP020)",
                    "displayName":  "Read Desk",
                    "appId":  "APP020",
                    "appName":  "Toriva Service Queue",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP020-ENT0125",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Toriva Service Queue"
                                     ],
                    "description":  "Read Desk permission within Toriva Service Queue (APP020)."
                },
    "ENT0126":  {
                    "entitlementId":  "ENT0126",
                    "name":  "Work Queue (APP020)",
                    "displayName":  "Work Queue",
                    "appId":  "APP020",
                    "appName":  "Toriva Service Queue",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP020-ENT0126",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Toriva Service Queue"
                                     ],
                    "description":  "Work Queue permission within Toriva Service Queue (APP020)."
                },
    "ENT0127":  {
                    "entitlementId":  "ENT0127",
                    "name":  "Case Review (APP020)",
                    "displayName":  "Case Review",
                    "appId":  "APP020",
                    "appName":  "Toriva Service Queue",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP020-ENT0127",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Toriva Service Queue"
                                     ],
                    "description":  "Case Review permission within Toriva Service Queue (APP020)."
                },
    "ENT0128":  {
                    "entitlementId":  "ENT0128",
                    "name":  "Report Export (APP020)",
                    "displayName":  "Report Export",
                    "appId":  "APP020",
                    "appName":  "Toriva Service Queue",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP020-ENT0128",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Toriva Service Queue"
                                     ],
                    "description":  "Report Export permission within Toriva Service Queue (APP020)."
                },
    "ENT0129":  {
                    "entitlementId":  "ENT0129",
                    "name":  "Exception Review (APP020)",
                    "displayName":  "Exception Review",
                    "appId":  "APP020",
                    "appName":  "Toriva Service Queue",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP020-ENT0129",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Toriva Service Queue"
                                     ],
                    "description":  "Exception Review permission within Toriva Service Queue (APP020)."
                },
    "ENT0130":  {
                    "entitlementId":  "ENT0130",
                    "name":  "Batch Control (APP020)",
                    "displayName":  "Batch Control",
                    "appId":  "APP020",
                    "appName":  "Toriva Service Queue",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP020-ENT0130",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Toriva Service Queue"
                                     ],
                    "description":  "Batch Control permission within Toriva Service Queue (APP020)."
                },
    "ENT0131":  {
                    "entitlementId":  "ENT0131",
                    "name":  "Read Desk (APP021)",
                    "displayName":  "Read Desk",
                    "appId":  "APP021",
                    "appName":  "Ulveno Case Board",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP021-ENT0131",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Ulveno Case Board"
                                     ],
                    "description":  "Read Desk permission within Ulveno Case Board (APP021)."
                },
    "ENT0132":  {
                    "entitlementId":  "ENT0132",
                    "name":  "Work Queue (APP021)",
                    "displayName":  "Work Queue",
                    "appId":  "APP021",
                    "appName":  "Ulveno Case Board",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP021-ENT0132",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Ulveno Case Board"
                                     ],
                    "description":  "Work Queue permission within Ulveno Case Board (APP021)."
                },
    "ENT0133":  {
                    "entitlementId":  "ENT0133",
                    "name":  "Case Review (APP021)",
                    "displayName":  "Case Review",
                    "appId":  "APP021",
                    "appName":  "Ulveno Case Board",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP021-ENT0133",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Ulveno Case Board"
                                     ],
                    "description":  "Case Review permission within Ulveno Case Board (APP021)."
                },
    "ENT0134":  {
                    "entitlementId":  "ENT0134",
                    "name":  "Report Export (APP021)",
                    "displayName":  "Report Export",
                    "appId":  "APP021",
                    "appName":  "Ulveno Case Board",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP021-ENT0134",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Ulveno Case Board"
                                     ],
                    "description":  "Report Export permission within Ulveno Case Board (APP021)."
                },
    "ENT0135":  {
                    "entitlementId":  "ENT0135",
                    "name":  "Exception Review (APP021)",
                    "displayName":  "Exception Review",
                    "appId":  "APP021",
                    "appName":  "Ulveno Case Board",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP021-ENT0135",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Ulveno Case Board"
                                     ],
                    "description":  "Exception Review permission within Ulveno Case Board (APP021)."
                },
    "ENT0136":  {
                    "entitlementId":  "ENT0136",
                    "name":  "Batch Control (APP021)",
                    "displayName":  "Batch Control",
                    "appId":  "APP021",
                    "appName":  "Ulveno Case Board",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP021-ENT0136",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Ulveno Case Board"
                                     ],
                    "description":  "Batch Control permission within Ulveno Case Board (APP021)."
                },
    "ENT0137":  {
                    "entitlementId":  "ENT0137",
                    "name":  "Read Desk (APP022)",
                    "displayName":  "Read Desk",
                    "appId":  "APP022",
                    "appName":  "Verixa Payment Studio",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP022-ENT0137",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Verixa Payment Studio"
                                     ],
                    "description":  "Read Desk permission within Verixa Payment Studio (APP022)."
                },
    "ENT0138":  {
                    "entitlementId":  "ENT0138",
                    "name":  "Work Queue (APP022)",
                    "displayName":  "Work Queue",
                    "appId":  "APP022",
                    "appName":  "Verixa Payment Studio",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP022-ENT0138",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Verixa Payment Studio"
                                     ],
                    "description":  "Work Queue permission within Verixa Payment Studio (APP022)."
                },
    "ENT0139":  {
                    "entitlementId":  "ENT0139",
                    "name":  "Case Review (APP022)",
                    "displayName":  "Case Review",
                    "appId":  "APP022",
                    "appName":  "Verixa Payment Studio",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP022-ENT0139",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Verixa Payment Studio"
                                     ],
                    "description":  "Case Review permission within Verixa Payment Studio (APP022)."
                },
    "ENT0140":  {
                    "entitlementId":  "ENT0140",
                    "name":  "Report Export (APP022)",
                    "displayName":  "Report Export",
                    "appId":  "APP022",
                    "appName":  "Verixa Payment Studio",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP022-ENT0140",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Verixa Payment Studio"
                                     ],
                    "description":  "Report Export permission within Verixa Payment Studio (APP022)."
                },
    "ENT0141":  {
                    "entitlementId":  "ENT0141",
                    "name":  "Exception Review (APP022)",
                    "displayName":  "Exception Review",
                    "appId":  "APP022",
                    "appName":  "Verixa Payment Studio",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP022-ENT0141",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Verixa Payment Studio"
                                     ],
                    "description":  "Exception Review permission within Verixa Payment Studio (APP022)."
                },
    "ENT0142":  {
                    "entitlementId":  "ENT0142",
                    "name":  "Batch Control (APP022)",
                    "displayName":  "Batch Control",
                    "appId":  "APP022",
                    "appName":  "Verixa Payment Studio",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP022-ENT0142",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Verixa Payment Studio"
                                     ],
                    "description":  "Batch Control permission within Verixa Payment Studio (APP022)."
                },
    "ENT0143":  {
                    "entitlementId":  "ENT0143",
                    "name":  "Read Desk (APP023)",
                    "displayName":  "Read Desk",
                    "appId":  "APP023",
                    "appName":  "Welora Risk Monitor",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP023-ENT0143",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Welora Risk Monitor"
                                     ],
                    "description":  "Read Desk permission within Welora Risk Monitor (APP023)."
                },
    "ENT0144":  {
                    "entitlementId":  "ENT0144",
                    "name":  "Work Queue (APP023)",
                    "displayName":  "Work Queue",
                    "appId":  "APP023",
                    "appName":  "Welora Risk Monitor",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP023-ENT0144",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Welora Risk Monitor"
                                     ],
                    "description":  "Work Queue permission within Welora Risk Monitor (APP023)."
                },
    "ENT0145":  {
                    "entitlementId":  "ENT0145",
                    "name":  "Case Review (APP023)",
                    "displayName":  "Case Review",
                    "appId":  "APP023",
                    "appName":  "Welora Risk Monitor",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP023-ENT0145",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Welora Risk Monitor"
                                     ],
                    "description":  "Case Review permission within Welora Risk Monitor (APP023)."
                },
    "ENT0146":  {
                    "entitlementId":  "ENT0146",
                    "name":  "Report Export (APP023)",
                    "displayName":  "Report Export",
                    "appId":  "APP023",
                    "appName":  "Welora Risk Monitor",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP023-ENT0146",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Welora Risk Monitor"
                                     ],
                    "description":  "Report Export permission within Welora Risk Monitor (APP023)."
                },
    "ENT0147":  {
                    "entitlementId":  "ENT0147",
                    "name":  "Exception Review (APP023)",
                    "displayName":  "Exception Review",
                    "appId":  "APP023",
                    "appName":  "Welora Risk Monitor",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP023-ENT0147",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Welora Risk Monitor"
                                     ],
                    "description":  "Exception Review permission within Welora Risk Monitor (APP023)."
                },
    "ENT0148":  {
                    "entitlementId":  "ENT0148",
                    "name":  "Batch Control (APP023)",
                    "displayName":  "Batch Control",
                    "appId":  "APP023",
                    "appName":  "Welora Risk Monitor",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP023-ENT0148",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Welora Risk Monitor"
                                     ],
                    "description":  "Batch Control permission within Welora Risk Monitor (APP023)."
                },
    "ENT0149":  {
                    "entitlementId":  "ENT0149",
                    "name":  "Read Desk (APP024)",
                    "displayName":  "Read Desk",
                    "appId":  "APP024",
                    "appName":  "Xaveli Access Console",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP024-ENT0149",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Xaveli Access Console"
                                     ],
                    "description":  "Read Desk permission within Xaveli Access Console (APP024)."
                },
    "ENT0150":  {
                    "entitlementId":  "ENT0150",
                    "name":  "Work Queue (APP024)",
                    "displayName":  "Work Queue",
                    "appId":  "APP024",
                    "appName":  "Xaveli Access Console",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP024-ENT0150",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Xaveli Access Console"
                                     ],
                    "description":  "Work Queue permission within Xaveli Access Console (APP024)."
                },
    "ENT0151":  {
                    "entitlementId":  "ENT0151",
                    "name":  "Case Review (APP024)",
                    "displayName":  "Case Review",
                    "appId":  "APP024",
                    "appName":  "Xaveli Access Console",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP024-ENT0151",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Xaveli Access Console"
                                     ],
                    "description":  "Case Review permission within Xaveli Access Console (APP024)."
                },
    "ENT0152":  {
                    "entitlementId":  "ENT0152",
                    "name":  "Report Export (APP024)",
                    "displayName":  "Report Export",
                    "appId":  "APP024",
                    "appName":  "Xaveli Access Console",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP024-ENT0152",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Xaveli Access Console"
                                     ],
                    "description":  "Report Export permission within Xaveli Access Console (APP024)."
                },
    "ENT0153":  {
                    "entitlementId":  "ENT0153",
                    "name":  "Exception Review (APP024)",
                    "displayName":  "Exception Review",
                    "appId":  "APP024",
                    "appName":  "Xaveli Access Console",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP024-ENT0153",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Xaveli Access Console"
                                     ],
                    "description":  "Exception Review permission within Xaveli Access Console (APP024)."
                },
    "ENT0154":  {
                    "entitlementId":  "ENT0154",
                    "name":  "Batch Control (APP024)",
                    "displayName":  "Batch Control",
                    "appId":  "APP024",
                    "appName":  "Xaveli Access Console",
                    "appCategory":  "Document Management",
                    "adGroup":  "SG-APP024-ENT0154",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Xaveli Access Console"
                                     ],
                    "description":  "Batch Control permission within Xaveli Access Console (APP024)."
                },
    "ENT0155":  {
                    "entitlementId":  "ENT0155",
                    "name":  "Read Desk (APP025)",
                    "displayName":  "Read Desk",
                    "appId":  "APP025",
                    "appName":  "Yorena Ledger Desk",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP025-ENT0155",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Yorena Ledger Desk"
                                     ],
                    "description":  "Read Desk permission within Yorena Ledger Desk (APP025)."
                },
    "ENT0156":  {
                    "entitlementId":  "ENT0156",
                    "name":  "Work Queue (APP025)",
                    "displayName":  "Work Queue",
                    "appId":  "APP025",
                    "appName":  "Yorena Ledger Desk",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP025-ENT0156",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Yorena Ledger Desk"
                                     ],
                    "description":  "Work Queue permission within Yorena Ledger Desk (APP025)."
                },
    "ENT0157":  {
                    "entitlementId":  "ENT0157",
                    "name":  "Case Review (APP025)",
                    "displayName":  "Case Review",
                    "appId":  "APP025",
                    "appName":  "Yorena Ledger Desk",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP025-ENT0157",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Yorena Ledger Desk"
                                     ],
                    "description":  "Case Review permission within Yorena Ledger Desk (APP025)."
                },
    "ENT0158":  {
                    "entitlementId":  "ENT0158",
                    "name":  "Report Export (APP025)",
                    "displayName":  "Report Export",
                    "appId":  "APP025",
                    "appName":  "Yorena Ledger Desk",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP025-ENT0158",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Yorena Ledger Desk"
                                     ],
                    "description":  "Report Export permission within Yorena Ledger Desk (APP025)."
                },
    "ENT0159":  {
                    "entitlementId":  "ENT0159",
                    "name":  "Exception Review (APP025)",
                    "displayName":  "Exception Review",
                    "appId":  "APP025",
                    "appName":  "Yorena Ledger Desk",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP025-ENT0159",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Yorena Ledger Desk"
                                     ],
                    "description":  "Exception Review permission within Yorena Ledger Desk (APP025)."
                },
    "ENT0160":  {
                    "entitlementId":  "ENT0160",
                    "name":  "Batch Control (APP025)",
                    "displayName":  "Batch Control",
                    "appId":  "APP025",
                    "appName":  "Yorena Ledger Desk",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP025-ENT0160",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Yorena Ledger Desk"
                                     ],
                    "description":  "Batch Control permission within Yorena Ledger Desk (APP025)."
                },
    "ENT0161":  {
                    "entitlementId":  "ENT0161",
                    "name":  "Read Desk (APP026)",
                    "displayName":  "Read Desk",
                    "appId":  "APP026",
                    "appName":  "Zelvian Report Hub",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP026-ENT0161",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Zelvian Report Hub"
                                     ],
                    "description":  "Read Desk permission within Zelvian Report Hub (APP026)."
                },
    "ENT0162":  {
                    "entitlementId":  "ENT0162",
                    "name":  "Work Queue (APP026)",
                    "displayName":  "Work Queue",
                    "appId":  "APP026",
                    "appName":  "Zelvian Report Hub",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP026-ENT0162",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Zelvian Report Hub"
                                     ],
                    "description":  "Work Queue permission within Zelvian Report Hub (APP026)."
                },
    "ENT0163":  {
                    "entitlementId":  "ENT0163",
                    "name":  "Case Review (APP026)",
                    "displayName":  "Case Review",
                    "appId":  "APP026",
                    "appName":  "Zelvian Report Hub",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP026-ENT0163",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Zelvian Report Hub"
                                     ],
                    "description":  "Case Review permission within Zelvian Report Hub (APP026)."
                },
    "ENT0164":  {
                    "entitlementId":  "ENT0164",
                    "name":  "Report Export (APP026)",
                    "displayName":  "Report Export",
                    "appId":  "APP026",
                    "appName":  "Zelvian Report Hub",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP026-ENT0164",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Zelvian Report Hub"
                                     ],
                    "description":  "Report Export permission within Zelvian Report Hub (APP026)."
                },
    "ENT0165":  {
                    "entitlementId":  "ENT0165",
                    "name":  "Exception Review (APP026)",
                    "displayName":  "Exception Review",
                    "appId":  "APP026",
                    "appName":  "Zelvian Report Hub",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP026-ENT0165",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Zelvian Report Hub"
                                     ],
                    "description":  "Exception Review permission within Zelvian Report Hub (APP026)."
                },
    "ENT0166":  {
                    "entitlementId":  "ENT0166",
                    "name":  "Batch Control (APP026)",
                    "displayName":  "Batch Control",
                    "appId":  "APP026",
                    "appName":  "Zelvian Report Hub",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP026-ENT0166",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Zelvian Report Hub"
                                     ],
                    "description":  "Batch Control permission within Zelvian Report Hub (APP026)."
                },
    "ENT0167":  {
                    "entitlementId":  "ENT0167",
                    "name":  "Read Desk (APP027)",
                    "displayName":  "Read Desk",
                    "appId":  "APP027",
                    "appName":  "Arvexa Document Vault",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP027-ENT0167",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Arvexa Document Vault"
                                     ],
                    "description":  "Read Desk permission within Arvexa Document Vault (APP027)."
                },
    "ENT0168":  {
                    "entitlementId":  "ENT0168",
                    "name":  "Work Queue (APP027)",
                    "displayName":  "Work Queue",
                    "appId":  "APP027",
                    "appName":  "Arvexa Document Vault",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP027-ENT0168",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Arvexa Document Vault"
                                     ],
                    "description":  "Work Queue permission within Arvexa Document Vault (APP027)."
                },
    "ENT0169":  {
                    "entitlementId":  "ENT0169",
                    "name":  "Case Review (APP027)",
                    "displayName":  "Case Review",
                    "appId":  "APP027",
                    "appName":  "Arvexa Document Vault",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP027-ENT0169",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Arvexa Document Vault"
                                     ],
                    "description":  "Case Review permission within Arvexa Document Vault (APP027)."
                },
    "ENT0170":  {
                    "entitlementId":  "ENT0170",
                    "name":  "Report Export (APP027)",
                    "displayName":  "Report Export",
                    "appId":  "APP027",
                    "appName":  "Arvexa Document Vault",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP027-ENT0170",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Arvexa Document Vault"
                                     ],
                    "description":  "Report Export permission within Arvexa Document Vault (APP027)."
                },
    "ENT0171":  {
                    "entitlementId":  "ENT0171",
                    "name":  "Exception Review (APP027)",
                    "displayName":  "Exception Review",
                    "appId":  "APP027",
                    "appName":  "Arvexa Document Vault",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP027-ENT0171",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Arvexa Document Vault"
                                     ],
                    "description":  "Exception Review permission within Arvexa Document Vault (APP027)."
                },
    "ENT0172":  {
                    "entitlementId":  "ENT0172",
                    "name":  "Batch Control (APP027)",
                    "displayName":  "Batch Control",
                    "appId":  "APP027",
                    "appName":  "Arvexa Document Vault",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP027-ENT0172",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Arvexa Document Vault"
                                     ],
                    "description":  "Batch Control permission within Arvexa Document Vault (APP027)."
                },
    "ENT0173":  {
                    "entitlementId":  "ENT0173",
                    "name":  "Read Desk (APP028)",
                    "displayName":  "Read Desk",
                    "appId":  "APP028",
                    "appName":  "Brenora Service Queue",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP028-ENT0173",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Brenora Service Queue"
                                     ],
                    "description":  "Read Desk permission within Brenora Service Queue (APP028)."
                },
    "ENT0174":  {
                    "entitlementId":  "ENT0174",
                    "name":  "Work Queue (APP028)",
                    "displayName":  "Work Queue",
                    "appId":  "APP028",
                    "appName":  "Brenora Service Queue",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP028-ENT0174",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Brenora Service Queue"
                                     ],
                    "description":  "Work Queue permission within Brenora Service Queue (APP028)."
                },
    "ENT0175":  {
                    "entitlementId":  "ENT0175",
                    "name":  "Case Review (APP028)",
                    "displayName":  "Case Review",
                    "appId":  "APP028",
                    "appName":  "Brenora Service Queue",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP028-ENT0175",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Brenora Service Queue"
                                     ],
                    "description":  "Case Review permission within Brenora Service Queue (APP028)."
                },
    "ENT0176":  {
                    "entitlementId":  "ENT0176",
                    "name":  "Report Export (APP028)",
                    "displayName":  "Report Export",
                    "appId":  "APP028",
                    "appName":  "Brenora Service Queue",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP028-ENT0176",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Brenora Service Queue"
                                     ],
                    "description":  "Report Export permission within Brenora Service Queue (APP028)."
                },
    "ENT0177":  {
                    "entitlementId":  "ENT0177",
                    "name":  "Exception Review (APP028)",
                    "displayName":  "Exception Review",
                    "appId":  "APP028",
                    "appName":  "Brenora Service Queue",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP028-ENT0177",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Brenora Service Queue"
                                     ],
                    "description":  "Exception Review permission within Brenora Service Queue (APP028)."
                },
    "ENT0178":  {
                    "entitlementId":  "ENT0178",
                    "name":  "Batch Control (APP028)",
                    "displayName":  "Batch Control",
                    "appId":  "APP028",
                    "appName":  "Brenora Service Queue",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP028-ENT0178",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Brenora Service Queue"
                                     ],
                    "description":  "Batch Control permission within Brenora Service Queue (APP028)."
                },
    "ENT0179":  {
                    "entitlementId":  "ENT0179",
                    "name":  "Read Desk (APP029)",
                    "displayName":  "Read Desk",
                    "appId":  "APP029",
                    "appName":  "Corvian Case Board",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP029-ENT0179",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Corvian Case Board"
                                     ],
                    "description":  "Read Desk permission within Corvian Case Board (APP029)."
                },
    "ENT0180":  {
                    "entitlementId":  "ENT0180",
                    "name":  "Work Queue (APP029)",
                    "displayName":  "Work Queue",
                    "appId":  "APP029",
                    "appName":  "Corvian Case Board",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP029-ENT0180",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Corvian Case Board"
                                     ],
                    "description":  "Work Queue permission within Corvian Case Board (APP029)."
                },
    "ENT0181":  {
                    "entitlementId":  "ENT0181",
                    "name":  "Case Review (APP029)",
                    "displayName":  "Case Review",
                    "appId":  "APP029",
                    "appName":  "Corvian Case Board",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP029-ENT0181",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Corvian Case Board"
                                     ],
                    "description":  "Case Review permission within Corvian Case Board (APP029)."
                },
    "ENT0182":  {
                    "entitlementId":  "ENT0182",
                    "name":  "Report Export (APP029)",
                    "displayName":  "Report Export",
                    "appId":  "APP029",
                    "appName":  "Corvian Case Board",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP029-ENT0182",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Corvian Case Board"
                                     ],
                    "description":  "Report Export permission within Corvian Case Board (APP029)."
                },
    "ENT0183":  {
                    "entitlementId":  "ENT0183",
                    "name":  "Exception Review (APP029)",
                    "displayName":  "Exception Review",
                    "appId":  "APP029",
                    "appName":  "Corvian Case Board",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP029-ENT0183",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Corvian Case Board"
                                     ],
                    "description":  "Exception Review permission within Corvian Case Board (APP029)."
                },
    "ENT0184":  {
                    "entitlementId":  "ENT0184",
                    "name":  "Batch Control (APP029)",
                    "displayName":  "Batch Control",
                    "appId":  "APP029",
                    "appName":  "Corvian Case Board",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP029-ENT0184",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Corvian Case Board"
                                     ],
                    "description":  "Batch Control permission within Corvian Case Board (APP029)."
                },
    "ENT0185":  {
                    "entitlementId":  "ENT0185",
                    "name":  "Read Desk (APP030)",
                    "displayName":  "Read Desk",
                    "appId":  "APP030",
                    "appName":  "Delenix Payment Studio",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP030-ENT0185",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Delenix Payment Studio"
                                     ],
                    "description":  "Read Desk permission within Delenix Payment Studio (APP030)."
                },
    "ENT0186":  {
                    "entitlementId":  "ENT0186",
                    "name":  "Work Queue (APP030)",
                    "displayName":  "Work Queue",
                    "appId":  "APP030",
                    "appName":  "Delenix Payment Studio",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP030-ENT0186",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Delenix Payment Studio"
                                     ],
                    "description":  "Work Queue permission within Delenix Payment Studio (APP030)."
                },
    "ENT0187":  {
                    "entitlementId":  "ENT0187",
                    "name":  "Case Review (APP030)",
                    "displayName":  "Case Review",
                    "appId":  "APP030",
                    "appName":  "Delenix Payment Studio",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP030-ENT0187",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Delenix Payment Studio"
                                     ],
                    "description":  "Case Review permission within Delenix Payment Studio (APP030)."
                },
    "ENT0188":  {
                    "entitlementId":  "ENT0188",
                    "name":  "Report Export (APP030)",
                    "displayName":  "Report Export",
                    "appId":  "APP030",
                    "appName":  "Delenix Payment Studio",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP030-ENT0188",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Delenix Payment Studio"
                                     ],
                    "description":  "Report Export permission within Delenix Payment Studio (APP030)."
                },
    "ENT0189":  {
                    "entitlementId":  "ENT0189",
                    "name":  "Exception Review (APP030)",
                    "displayName":  "Exception Review",
                    "appId":  "APP030",
                    "appName":  "Delenix Payment Studio",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP030-ENT0189",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Delenix Payment Studio"
                                     ],
                    "description":  "Exception Review permission within Delenix Payment Studio (APP030)."
                },
    "ENT0190":  {
                    "entitlementId":  "ENT0190",
                    "name":  "Batch Control (APP030)",
                    "displayName":  "Batch Control",
                    "appId":  "APP030",
                    "appName":  "Delenix Payment Studio",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP030-ENT0190",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Delenix Payment Studio"
                                     ],
                    "description":  "Batch Control permission within Delenix Payment Studio (APP030)."
                },
    "ENT0191":  {
                    "entitlementId":  "ENT0191",
                    "name":  "Read Desk (APP031)",
                    "displayName":  "Read Desk",
                    "appId":  "APP031",
                    "appName":  "Evaron Risk Monitor",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP031-ENT0191",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Evaron Risk Monitor"
                                     ],
                    "description":  "Read Desk permission within Evaron Risk Monitor (APP031)."
                },
    "ENT0192":  {
                    "entitlementId":  "ENT0192",
                    "name":  "Work Queue (APP031)",
                    "displayName":  "Work Queue",
                    "appId":  "APP031",
                    "appName":  "Evaron Risk Monitor",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP031-ENT0192",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Evaron Risk Monitor"
                                     ],
                    "description":  "Work Queue permission within Evaron Risk Monitor (APP031)."
                },
    "ENT0193":  {
                    "entitlementId":  "ENT0193",
                    "name":  "Case Review (APP031)",
                    "displayName":  "Case Review",
                    "appId":  "APP031",
                    "appName":  "Evaron Risk Monitor",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP031-ENT0193",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Evaron Risk Monitor"
                                     ],
                    "description":  "Case Review permission within Evaron Risk Monitor (APP031)."
                },
    "ENT0194":  {
                    "entitlementId":  "ENT0194",
                    "name":  "Report Export (APP031)",
                    "displayName":  "Report Export",
                    "appId":  "APP031",
                    "appName":  "Evaron Risk Monitor",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP031-ENT0194",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Evaron Risk Monitor"
                                     ],
                    "description":  "Report Export permission within Evaron Risk Monitor (APP031)."
                },
    "ENT0195":  {
                    "entitlementId":  "ENT0195",
                    "name":  "Exception Review (APP031)",
                    "displayName":  "Exception Review",
                    "appId":  "APP031",
                    "appName":  "Evaron Risk Monitor",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP031-ENT0195",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Evaron Risk Monitor"
                                     ],
                    "description":  "Exception Review permission within Evaron Risk Monitor (APP031)."
                },
    "ENT0196":  {
                    "entitlementId":  "ENT0196",
                    "name":  "Batch Control (APP031)",
                    "displayName":  "Batch Control",
                    "appId":  "APP031",
                    "appName":  "Evaron Risk Monitor",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP031-ENT0196",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Evaron Risk Monitor"
                                     ],
                    "description":  "Batch Control permission within Evaron Risk Monitor (APP031)."
                },
    "ENT0197":  {
                    "entitlementId":  "ENT0197",
                    "name":  "Read Desk (APP032)",
                    "displayName":  "Read Desk",
                    "appId":  "APP032",
                    "appName":  "Folvira Access Console",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP032-ENT0197",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Folvira Access Console"
                                     ],
                    "description":  "Read Desk permission within Folvira Access Console (APP032)."
                },
    "ENT0198":  {
                    "entitlementId":  "ENT0198",
                    "name":  "Work Queue (APP032)",
                    "displayName":  "Work Queue",
                    "appId":  "APP032",
                    "appName":  "Folvira Access Console",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP032-ENT0198",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Folvira Access Console"
                                     ],
                    "description":  "Work Queue permission within Folvira Access Console (APP032)."
                },
    "ENT0199":  {
                    "entitlementId":  "ENT0199",
                    "name":  "Case Review (APP032)",
                    "displayName":  "Case Review",
                    "appId":  "APP032",
                    "appName":  "Folvira Access Console",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP032-ENT0199",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Folvira Access Console"
                                     ],
                    "description":  "Case Review permission within Folvira Access Console (APP032)."
                },
    "ENT0200":  {
                    "entitlementId":  "ENT0200",
                    "name":  "Report Export (APP032)",
                    "displayName":  "Report Export",
                    "appId":  "APP032",
                    "appName":  "Folvira Access Console",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP032-ENT0200",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Folvira Access Console"
                                     ],
                    "description":  "Report Export permission within Folvira Access Console (APP032)."
                },
    "ENT0201":  {
                    "entitlementId":  "ENT0201",
                    "name":  "Exception Review (APP032)",
                    "displayName":  "Exception Review",
                    "appId":  "APP032",
                    "appName":  "Folvira Access Console",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP032-ENT0201",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Folvira Access Console"
                                     ],
                    "description":  "Exception Review permission within Folvira Access Console (APP032)."
                },
    "ENT0202":  {
                    "entitlementId":  "ENT0202",
                    "name":  "Batch Control (APP032)",
                    "displayName":  "Batch Control",
                    "appId":  "APP032",
                    "appName":  "Folvira Access Console",
                    "appCategory":  "Customer Servicing",
                    "adGroup":  "SG-APP032-ENT0202",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Folvira Access Console"
                                     ],
                    "description":  "Batch Control permission within Folvira Access Console (APP032)."
                },
    "ENT0203":  {
                    "entitlementId":  "ENT0203",
                    "name":  "Read Desk (APP033)",
                    "displayName":  "Read Desk",
                    "appId":  "APP033",
                    "appName":  "Gorena Ledger Desk",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP033-ENT0203",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Gorena Ledger Desk"
                                     ],
                    "description":  "Read Desk permission within Gorena Ledger Desk (APP033)."
                },
    "ENT0204":  {
                    "entitlementId":  "ENT0204",
                    "name":  "Work Queue (APP033)",
                    "displayName":  "Work Queue",
                    "appId":  "APP033",
                    "appName":  "Gorena Ledger Desk",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP033-ENT0204",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Gorena Ledger Desk"
                                     ],
                    "description":  "Work Queue permission within Gorena Ledger Desk (APP033)."
                },
    "ENT0205":  {
                    "entitlementId":  "ENT0205",
                    "name":  "Case Review (APP033)",
                    "displayName":  "Case Review",
                    "appId":  "APP033",
                    "appName":  "Gorena Ledger Desk",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP033-ENT0205",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Gorena Ledger Desk"
                                     ],
                    "description":  "Case Review permission within Gorena Ledger Desk (APP033)."
                },
    "ENT0206":  {
                    "entitlementId":  "ENT0206",
                    "name":  "Report Export (APP033)",
                    "displayName":  "Report Export",
                    "appId":  "APP033",
                    "appName":  "Gorena Ledger Desk",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP033-ENT0206",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Gorena Ledger Desk"
                                     ],
                    "description":  "Report Export permission within Gorena Ledger Desk (APP033)."
                },
    "ENT0207":  {
                    "entitlementId":  "ENT0207",
                    "name":  "Exception Review (APP033)",
                    "displayName":  "Exception Review",
                    "appId":  "APP033",
                    "appName":  "Gorena Ledger Desk",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP033-ENT0207",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Gorena Ledger Desk"
                                     ],
                    "description":  "Exception Review permission within Gorena Ledger Desk (APP033)."
                },
    "ENT0208":  {
                    "entitlementId":  "ENT0208",
                    "name":  "Batch Control (APP033)",
                    "displayName":  "Batch Control",
                    "appId":  "APP033",
                    "appName":  "Gorena Ledger Desk",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP033-ENT0208",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Gorena Ledger Desk"
                                     ],
                    "description":  "Batch Control permission within Gorena Ledger Desk (APP033)."
                },
    "ENT0209":  {
                    "entitlementId":  "ENT0209",
                    "name":  "Read Desk (APP034)",
                    "displayName":  "Read Desk",
                    "appId":  "APP034",
                    "appName":  "Helvian Report Hub",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP034-ENT0209",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Helvian Report Hub"
                                     ],
                    "description":  "Read Desk permission within Helvian Report Hub (APP034)."
                },
    "ENT0210":  {
                    "entitlementId":  "ENT0210",
                    "name":  "Work Queue (APP034)",
                    "displayName":  "Work Queue",
                    "appId":  "APP034",
                    "appName":  "Helvian Report Hub",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP034-ENT0210",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Helvian Report Hub"
                                     ],
                    "description":  "Work Queue permission within Helvian Report Hub (APP034)."
                },
    "ENT0211":  {
                    "entitlementId":  "ENT0211",
                    "name":  "Case Review (APP034)",
                    "displayName":  "Case Review",
                    "appId":  "APP034",
                    "appName":  "Helvian Report Hub",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP034-ENT0211",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Helvian Report Hub"
                                     ],
                    "description":  "Case Review permission within Helvian Report Hub (APP034)."
                },
    "ENT0212":  {
                    "entitlementId":  "ENT0212",
                    "name":  "Report Export (APP034)",
                    "displayName":  "Report Export",
                    "appId":  "APP034",
                    "appName":  "Helvian Report Hub",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP034-ENT0212",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Helvian Report Hub"
                                     ],
                    "description":  "Report Export permission within Helvian Report Hub (APP034)."
                },
    "ENT0213":  {
                    "entitlementId":  "ENT0213",
                    "name":  "Exception Review (APP034)",
                    "displayName":  "Exception Review",
                    "appId":  "APP034",
                    "appName":  "Helvian Report Hub",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP034-ENT0213",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Helvian Report Hub"
                                     ],
                    "description":  "Exception Review permission within Helvian Report Hub (APP034)."
                },
    "ENT0214":  {
                    "entitlementId":  "ENT0214",
                    "name":  "Batch Control (APP034)",
                    "displayName":  "Batch Control",
                    "appId":  "APP034",
                    "appName":  "Helvian Report Hub",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP034-ENT0214",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Helvian Report Hub"
                                     ],
                    "description":  "Batch Control permission within Helvian Report Hub (APP034)."
                },
    "ENT0215":  {
                    "entitlementId":  "ENT0215",
                    "name":  "Read Desk (APP035)",
                    "displayName":  "Read Desk",
                    "appId":  "APP035",
                    "appName":  "Ilenor Document Vault",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP035-ENT0215",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Ilenor Document Vault"
                                     ],
                    "description":  "Read Desk permission within Ilenor Document Vault (APP035)."
                },
    "ENT0216":  {
                    "entitlementId":  "ENT0216",
                    "name":  "Work Queue (APP035)",
                    "displayName":  "Work Queue",
                    "appId":  "APP035",
                    "appName":  "Ilenor Document Vault",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP035-ENT0216",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Ilenor Document Vault"
                                     ],
                    "description":  "Work Queue permission within Ilenor Document Vault (APP035)."
                },
    "ENT0217":  {
                    "entitlementId":  "ENT0217",
                    "name":  "Case Review (APP035)",
                    "displayName":  "Case Review",
                    "appId":  "APP035",
                    "appName":  "Ilenor Document Vault",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP035-ENT0217",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Ilenor Document Vault"
                                     ],
                    "description":  "Case Review permission within Ilenor Document Vault (APP035)."
                },
    "ENT0218":  {
                    "entitlementId":  "ENT0218",
                    "name":  "Report Export (APP035)",
                    "displayName":  "Report Export",
                    "appId":  "APP035",
                    "appName":  "Ilenor Document Vault",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP035-ENT0218",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Ilenor Document Vault"
                                     ],
                    "description":  "Report Export permission within Ilenor Document Vault (APP035)."
                },
    "ENT0219":  {
                    "entitlementId":  "ENT0219",
                    "name":  "Exception Review (APP035)",
                    "displayName":  "Exception Review",
                    "appId":  "APP035",
                    "appName":  "Ilenor Document Vault",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP035-ENT0219",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Ilenor Document Vault"
                                     ],
                    "description":  "Exception Review permission within Ilenor Document Vault (APP035)."
                },
    "ENT0220":  {
                    "entitlementId":  "ENT0220",
                    "name":  "Batch Control (APP035)",
                    "displayName":  "Batch Control",
                    "appId":  "APP035",
                    "appName":  "Ilenor Document Vault",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP035-ENT0220",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Ilenor Document Vault"
                                     ],
                    "description":  "Batch Control permission within Ilenor Document Vault (APP035)."
                },
    "ENT0221":  {
                    "entitlementId":  "ENT0221",
                    "name":  "Read Desk (APP036)",
                    "displayName":  "Read Desk",
                    "appId":  "APP036",
                    "appName":  "Jovexa Service Queue",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP036-ENT0221",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Jovexa Service Queue"
                                     ],
                    "description":  "Read Desk permission within Jovexa Service Queue (APP036)."
                },
    "ENT0222":  {
                    "entitlementId":  "ENT0222",
                    "name":  "Work Queue (APP036)",
                    "displayName":  "Work Queue",
                    "appId":  "APP036",
                    "appName":  "Jovexa Service Queue",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP036-ENT0222",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Jovexa Service Queue"
                                     ],
                    "description":  "Work Queue permission within Jovexa Service Queue (APP036)."
                },
    "ENT0223":  {
                    "entitlementId":  "ENT0223",
                    "name":  "Case Review (APP036)",
                    "displayName":  "Case Review",
                    "appId":  "APP036",
                    "appName":  "Jovexa Service Queue",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP036-ENT0223",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Jovexa Service Queue"
                                     ],
                    "description":  "Case Review permission within Jovexa Service Queue (APP036)."
                },
    "ENT0224":  {
                    "entitlementId":  "ENT0224",
                    "name":  "Report Export (APP036)",
                    "displayName":  "Report Export",
                    "appId":  "APP036",
                    "appName":  "Jovexa Service Queue",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP036-ENT0224",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Jovexa Service Queue"
                                     ],
                    "description":  "Report Export permission within Jovexa Service Queue (APP036)."
                },
    "ENT0225":  {
                    "entitlementId":  "ENT0225",
                    "name":  "Exception Review (APP036)",
                    "displayName":  "Exception Review",
                    "appId":  "APP036",
                    "appName":  "Jovexa Service Queue",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP036-ENT0225",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Jovexa Service Queue"
                                     ],
                    "description":  "Exception Review permission within Jovexa Service Queue (APP036)."
                },
    "ENT0226":  {
                    "entitlementId":  "ENT0226",
                    "name":  "Batch Control (APP036)",
                    "displayName":  "Batch Control",
                    "appId":  "APP036",
                    "appName":  "Jovexa Service Queue",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP036-ENT0226",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Jovexa Service Queue"
                                     ],
                    "description":  "Batch Control permission within Jovexa Service Queue (APP036)."
                },
    "ENT0227":  {
                    "entitlementId":  "ENT0227",
                    "name":  "Read Desk (APP037)",
                    "displayName":  "Read Desk",
                    "appId":  "APP037",
                    "appName":  "Kavira Case Board",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP037-ENT0227",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Kavira Case Board"
                                     ],
                    "description":  "Read Desk permission within Kavira Case Board (APP037)."
                },
    "ENT0228":  {
                    "entitlementId":  "ENT0228",
                    "name":  "Work Queue (APP037)",
                    "displayName":  "Work Queue",
                    "appId":  "APP037",
                    "appName":  "Kavira Case Board",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP037-ENT0228",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Kavira Case Board"
                                     ],
                    "description":  "Work Queue permission within Kavira Case Board (APP037)."
                },
    "ENT0229":  {
                    "entitlementId":  "ENT0229",
                    "name":  "Case Review (APP037)",
                    "displayName":  "Case Review",
                    "appId":  "APP037",
                    "appName":  "Kavira Case Board",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP037-ENT0229",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Kavira Case Board"
                                     ],
                    "description":  "Case Review permission within Kavira Case Board (APP037)."
                },
    "ENT0230":  {
                    "entitlementId":  "ENT0230",
                    "name":  "Report Export (APP037)",
                    "displayName":  "Report Export",
                    "appId":  "APP037",
                    "appName":  "Kavira Case Board",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP037-ENT0230",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Kavira Case Board"
                                     ],
                    "description":  "Report Export permission within Kavira Case Board (APP037)."
                },
    "ENT0231":  {
                    "entitlementId":  "ENT0231",
                    "name":  "Exception Review (APP037)",
                    "displayName":  "Exception Review",
                    "appId":  "APP037",
                    "appName":  "Kavira Case Board",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP037-ENT0231",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Kavira Case Board"
                                     ],
                    "description":  "Exception Review permission within Kavira Case Board (APP037)."
                },
    "ENT0232":  {
                    "entitlementId":  "ENT0232",
                    "name":  "Batch Control (APP037)",
                    "displayName":  "Batch Control",
                    "appId":  "APP037",
                    "appName":  "Kavira Case Board",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP037-ENT0232",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Kavira Case Board"
                                     ],
                    "description":  "Batch Control permission within Kavira Case Board (APP037)."
                },
    "ENT0233":  {
                    "entitlementId":  "ENT0233",
                    "name":  "Read Desk (APP038)",
                    "displayName":  "Read Desk",
                    "appId":  "APP038",
                    "appName":  "Lerovo Payment Studio",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP038-ENT0233",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Lerovo Payment Studio"
                                     ],
                    "description":  "Read Desk permission within Lerovo Payment Studio (APP038)."
                },
    "ENT0234":  {
                    "entitlementId":  "ENT0234",
                    "name":  "Work Queue (APP038)",
                    "displayName":  "Work Queue",
                    "appId":  "APP038",
                    "appName":  "Lerovo Payment Studio",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP038-ENT0234",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Lerovo Payment Studio"
                                     ],
                    "description":  "Work Queue permission within Lerovo Payment Studio (APP038)."
                },
    "ENT0235":  {
                    "entitlementId":  "ENT0235",
                    "name":  "Case Review (APP038)",
                    "displayName":  "Case Review",
                    "appId":  "APP038",
                    "appName":  "Lerovo Payment Studio",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP038-ENT0235",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Lerovo Payment Studio"
                                     ],
                    "description":  "Case Review permission within Lerovo Payment Studio (APP038)."
                },
    "ENT0236":  {
                    "entitlementId":  "ENT0236",
                    "name":  "Report Export (APP038)",
                    "displayName":  "Report Export",
                    "appId":  "APP038",
                    "appName":  "Lerovo Payment Studio",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP038-ENT0236",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Lerovo Payment Studio"
                                     ],
                    "description":  "Report Export permission within Lerovo Payment Studio (APP038)."
                },
    "ENT0237":  {
                    "entitlementId":  "ENT0237",
                    "name":  "Exception Review (APP038)",
                    "displayName":  "Exception Review",
                    "appId":  "APP038",
                    "appName":  "Lerovo Payment Studio",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP038-ENT0237",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Lerovo Payment Studio"
                                     ],
                    "description":  "Exception Review permission within Lerovo Payment Studio (APP038)."
                },
    "ENT0238":  {
                    "entitlementId":  "ENT0238",
                    "name":  "Batch Control (APP038)",
                    "displayName":  "Batch Control",
                    "appId":  "APP038",
                    "appName":  "Lerovo Payment Studio",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP038-ENT0238",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Lerovo Payment Studio"
                                     ],
                    "description":  "Batch Control permission within Lerovo Payment Studio (APP038)."
                },
    "ENT0239":  {
                    "entitlementId":  "ENT0239",
                    "name":  "Read Desk (APP039)",
                    "displayName":  "Read Desk",
                    "appId":  "APP039",
                    "appName":  "Morvian Risk Monitor",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP039-ENT0239",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Morvian Risk Monitor"
                                     ],
                    "description":  "Read Desk permission within Morvian Risk Monitor (APP039)."
                },
    "ENT0240":  {
                    "entitlementId":  "ENT0240",
                    "name":  "Work Queue (APP039)",
                    "displayName":  "Work Queue",
                    "appId":  "APP039",
                    "appName":  "Morvian Risk Monitor",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP039-ENT0240",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Morvian Risk Monitor"
                                     ],
                    "description":  "Work Queue permission within Morvian Risk Monitor (APP039)."
                },
    "ENT0241":  {
                    "entitlementId":  "ENT0241",
                    "name":  "Case Review (APP039)",
                    "displayName":  "Case Review",
                    "appId":  "APP039",
                    "appName":  "Morvian Risk Monitor",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP039-ENT0241",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Morvian Risk Monitor"
                                     ],
                    "description":  "Case Review permission within Morvian Risk Monitor (APP039)."
                },
    "ENT0242":  {
                    "entitlementId":  "ENT0242",
                    "name":  "Report Export (APP039)",
                    "displayName":  "Report Export",
                    "appId":  "APP039",
                    "appName":  "Morvian Risk Monitor",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP039-ENT0242",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Morvian Risk Monitor"
                                     ],
                    "description":  "Report Export permission within Morvian Risk Monitor (APP039)."
                },
    "ENT0243":  {
                    "entitlementId":  "ENT0243",
                    "name":  "Exception Review (APP039)",
                    "displayName":  "Exception Review",
                    "appId":  "APP039",
                    "appName":  "Morvian Risk Monitor",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP039-ENT0243",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Morvian Risk Monitor"
                                     ],
                    "description":  "Exception Review permission within Morvian Risk Monitor (APP039)."
                },
    "ENT0244":  {
                    "entitlementId":  "ENT0244",
                    "name":  "Batch Control (APP039)",
                    "displayName":  "Batch Control",
                    "appId":  "APP039",
                    "appName":  "Morvian Risk Monitor",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP039-ENT0244",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Morvian Risk Monitor"
                                     ],
                    "description":  "Batch Control permission within Morvian Risk Monitor (APP039)."
                },
    "ENT0245":  {
                    "entitlementId":  "ENT0245",
                    "name":  "Read Desk (APP040)",
                    "displayName":  "Read Desk",
                    "appId":  "APP040",
                    "appName":  "Nuvexa Access Console",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP040-ENT0245",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Nuvexa Access Console"
                                     ],
                    "description":  "Read Desk permission within Nuvexa Access Console (APP040)."
                },
    "ENT0246":  {
                    "entitlementId":  "ENT0246",
                    "name":  "Work Queue (APP040)",
                    "displayName":  "Work Queue",
                    "appId":  "APP040",
                    "appName":  "Nuvexa Access Console",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP040-ENT0246",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Nuvexa Access Console"
                                     ],
                    "description":  "Work Queue permission within Nuvexa Access Console (APP040)."
                },
    "ENT0247":  {
                    "entitlementId":  "ENT0247",
                    "name":  "Case Review (APP040)",
                    "displayName":  "Case Review",
                    "appId":  "APP040",
                    "appName":  "Nuvexa Access Console",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP040-ENT0247",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Nuvexa Access Console"
                                     ],
                    "description":  "Case Review permission within Nuvexa Access Console (APP040)."
                },
    "ENT0248":  {
                    "entitlementId":  "ENT0248",
                    "name":  "Report Export (APP040)",
                    "displayName":  "Report Export",
                    "appId":  "APP040",
                    "appName":  "Nuvexa Access Console",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP040-ENT0248",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Read",
                    "applications":  [
                                         "Nuvexa Access Console"
                                     ],
                    "description":  "Report Export permission within Nuvexa Access Console (APP040)."
                },
    "ENT0249":  {
                    "entitlementId":  "ENT0249",
                    "name":  "Exception Review (APP040)",
                    "displayName":  "Exception Review",
                    "appId":  "APP040",
                    "appName":  "Nuvexa Access Console",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP040-ENT0249",
                    "risk":  "High Risk · Privileged Access",
                    "accessLevel":  "Elevated",
                    "applications":  [
                                         "Nuvexa Access Console"
                                     ],
                    "description":  "Exception Review permission within Nuvexa Access Console (APP040)."
                },
    "ENT0250":  {
                    "entitlementId":  "ENT0250",
                    "name":  "Batch Control (APP040)",
                    "displayName":  "Batch Control",
                    "appId":  "APP040",
                    "appName":  "Nuvexa Access Console",
                    "appCategory":  "Case Management",
                    "adGroup":  "SG-APP040-ENT0250",
                    "risk":  "Standard Risk · Pre-Approved",
                    "accessLevel":  "Standard",
                    "applications":  [
                                         "Nuvexa Access Console"
                                     ],
                    "description":  "Batch Control permission within Nuvexa Access Console (APP040)."
                }
};

export const BASELINE_ROLES = {
    "BR0001":  {
                   "roleId":  "BR0001",
                   "title":  "Client Account Associate (US) · BR0001",
                   "jobTitle":  "Client Account Associate",
                   "department":  "Client Accounts",
                   "region":  "US",
                   "costCenter":  "101",
                   "description":  "Client Account Associate in US (Cost Center 101).",
                   "entitlements":  [
                                        "ENT0009",
                                        "ENT0222",
                                        "ENT0033",
                                        "ENT0123",
                                        "ENT0047",
                                        "ENT0010",
                                        "ENT0086",
                                        "ENT0194",
                                        "ENT0128",
                                        "ENT0031",
                                        "ENT0126"
                                    ],
                   "ownerEmployeeId":  "GID0113",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0002":  {
                   "roleId":  "BR0002",
                   "title":  "Client Account Specialist (US) · BR0002",
                   "jobTitle":  "Client Account Specialist",
                   "department":  "Client Accounts",
                   "region":  "US",
                   "costCenter":  "102",
                   "description":  "Client Account Specialist in US (Cost Center 102).",
                   "entitlements":  [
                                        "ENT0065",
                                        "ENT0011",
                                        "ENT0133",
                                        "ENT0038",
                                        "ENT0126",
                                        "ENT0203",
                                        "ENT0199",
                                        "ENT0021",
                                        "ENT0063",
                                        "ENT0143",
                                        "ENT0144"
                                    ],
                   "ownerEmployeeId":  "GID0018",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0003":  {
                   "roleId":  "BR0003",
                   "title":  "Client Account Lead (US) · BR0003",
                   "jobTitle":  "Client Account Lead",
                   "department":  "Client Accounts",
                   "region":  "US",
                   "costCenter":  "103",
                   "description":  "Client Account Lead in US (Cost Center 103).",
                   "entitlements":  [
                                        "ENT0120",
                                        "ENT0086",
                                        "ENT0101",
                                        "ENT0124",
                                        "ENT0202",
                                        "ENT0051",
                                        "ENT0127",
                                        "ENT0088",
                                        "ENT0194",
                                        "ENT0009",
                                        "ENT0036"
                                    ],
                   "ownerEmployeeId":  "GID0047",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0004":  {
                   "roleId":  "BR0004",
                   "title":  "Payment Operations Associate (US) · BR0004",
                   "jobTitle":  "Payment Operations Associate",
                   "department":  "Payment Operations",
                   "region":  "US",
                   "costCenter":  "104",
                   "description":  "Payment Operations Associate in US (Cost Center 104).",
                   "entitlements":  [
                                        "ENT0130",
                                        "ENT0045",
                                        "ENT0042",
                                        "ENT0173",
                                        "ENT0210",
                                        "ENT0057",
                                        "ENT0073",
                                        "ENT0095",
                                        "ENT0098",
                                        "ENT0031",
                                        "ENT0107"
                                    ],
                   "ownerEmployeeId":  "GID0015",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0005":  {
                   "roleId":  "BR0005",
                   "title":  "Payment Operations Specialist (US) · BR0005",
                   "jobTitle":  "Payment Operations Specialist",
                   "department":  "Payment Operations",
                   "region":  "US",
                   "costCenter":  "105",
                   "description":  "Payment Operations Specialist in US (Cost Center 105).",
                   "entitlements":  [
                                        "ENT0008",
                                        "ENT0087",
                                        "ENT0093",
                                        "ENT0072",
                                        "ENT0154",
                                        "ENT0038",
                                        "ENT0050",
                                        "ENT0140",
                                        "ENT0219",
                                        "ENT0113"
                                    ],
                   "ownerEmployeeId":  "GID0008",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0006":  {
                   "roleId":  "BR0006",
                   "title":  "Payment Operations Lead (US) · BR0006",
                   "jobTitle":  "Payment Operations Lead",
                   "department":  "Payment Operations",
                   "region":  "US",
                   "costCenter":  "106",
                   "description":  "Payment Operations Lead in US (Cost Center 106).",
                   "entitlements":  [
                                        "ENT0068",
                                        "ENT0152",
                                        "ENT0163",
                                        "ENT0217",
                                        "ENT0150",
                                        "ENT0100",
                                        "ENT0072",
                                        "ENT0174",
                                        "ENT0134",
                                        "ENT0011",
                                        "ENT0015"
                                    ],
                   "ownerEmployeeId":  "GID0033",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0007":  {
                   "roleId":  "BR0007",
                   "title":  "Credit Review Associate (US) · BR0007",
                   "jobTitle":  "Credit Review Associate",
                   "department":  "Credit \u0026 Underwriting",
                   "region":  "US",
                   "costCenter":  "107",
                   "description":  "Credit Review Associate in US (Cost Center 107).",
                   "entitlements":  [
                                        "ENT0179",
                                        "ENT0108",
                                        "ENT0089",
                                        "ENT0053",
                                        "ENT0076",
                                        "ENT0131",
                                        "ENT0166",
                                        "ENT0188",
                                        "ENT0047",
                                        "ENT0049",
                                        "ENT0173"
                                    ],
                   "ownerEmployeeId":  "GID0021",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0008":  {
                   "roleId":  "BR0008",
                   "title":  "Credit Review Specialist (US) · BR0008",
                   "jobTitle":  "Credit Review Specialist",
                   "department":  "Credit \u0026 Underwriting",
                   "region":  "US",
                   "costCenter":  "108",
                   "description":  "Credit Review Specialist in US (Cost Center 108).",
                   "entitlements":  [
                                        "ENT0142",
                                        "ENT0013",
                                        "ENT0040",
                                        "ENT0203",
                                        "ENT0065",
                                        "ENT0162",
                                        "ENT0190",
                                        "ENT0085",
                                        "ENT0002",
                                        "ENT0081",
                                        "ENT0186"
                                    ],
                   "ownerEmployeeId":  "GID0004",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0009":  {
                   "roleId":  "BR0009",
                   "title":  "Credit Review Lead (US) · BR0009",
                   "jobTitle":  "Credit Review Lead",
                   "department":  "Credit \u0026 Underwriting",
                   "region":  "US",
                   "costCenter":  "109",
                   "description":  "Credit Review Lead in US (Cost Center 109).",
                   "entitlements":  [
                                        "ENT0147",
                                        "ENT0012",
                                        "ENT0100",
                                        "ENT0201",
                                        "ENT0204",
                                        "ENT0179",
                                        "ENT0189",
                                        "ENT0027",
                                        "ENT0197",
                                        "ENT0219",
                                        "ENT0211"
                                    ],
                   "ownerEmployeeId":  "GID0052",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0010":  {
                   "roleId":  "BR0010",
                   "title":  "Portfolio Reporting Analyst (US) · BR0010",
                   "jobTitle":  "Portfolio Reporting Analyst",
                   "department":  "Portfolio Reporting",
                   "region":  "US",
                   "costCenter":  "110",
                   "description":  "Portfolio Reporting Analyst in US (Cost Center 110).",
                   "entitlements":  [
                                        "ENT0052",
                                        "ENT0129",
                                        "ENT0145",
                                        "ENT0128",
                                        "ENT0226",
                                        "ENT0197",
                                        "ENT0029",
                                        "ENT0016",
                                        "ENT0001",
                                        "ENT0118",
                                        "ENT0136"
                                    ],
                   "ownerEmployeeId":  "GID0053",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0011":  {
                   "roleId":  "BR0011",
                   "title":  "Portfolio Reporting Specialist (US) · BR0011",
                   "jobTitle":  "Portfolio Reporting Specialist",
                   "department":  "Portfolio Reporting",
                   "region":  "US",
                   "costCenter":  "111",
                   "description":  "Portfolio Reporting Specialist in US (Cost Center 111).",
                   "entitlements":  [
                                        "ENT0223",
                                        "ENT0086",
                                        "ENT0068",
                                        "ENT0051",
                                        "ENT0142",
                                        "ENT0109",
                                        "ENT0194",
                                        "ENT0074",
                                        "ENT0110",
                                        "ENT0145",
                                        "ENT0015"
                                    ],
                   "ownerEmployeeId":  "GID0036",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0012":  {
                   "roleId":  "BR0012",
                   "title":  "Portfolio Reporting Lead (US) · BR0012",
                   "jobTitle":  "Portfolio Reporting Lead",
                   "department":  "Portfolio Reporting",
                   "region":  "US",
                   "costCenter":  "112",
                   "description":  "Portfolio Reporting Lead in US (Cost Center 112).",
                   "entitlements":  [
                                        "ENT0155",
                                        "ENT0102",
                                        "ENT0079",
                                        "ENT0169",
                                        "ENT0099",
                                        "ENT0018",
                                        "ENT0217",
                                        "ENT0187",
                                        "ENT0112",
                                        "ENT0226",
                                        "ENT0222"
                                    ],
                   "ownerEmployeeId":  "GID0023",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0013":  {
                   "roleId":  "BR0013",
                   "title":  "Document Control Associate (US) · BR0013",
                   "jobTitle":  "Document Control Associate",
                   "department":  "Document Management",
                   "region":  "US",
                   "costCenter":  "113",
                   "description":  "Document Control Associate in US (Cost Center 113).",
                   "entitlements":  [
                                        "ENT0096",
                                        "ENT0165",
                                        "ENT0127",
                                        "ENT0150",
                                        "ENT0147",
                                        "ENT0091",
                                        "ENT0131",
                                        "ENT0146",
                                        "ENT0095",
                                        "ENT0153",
                                        "ENT0205"
                                    ],
                   "ownerEmployeeId":  "GID0059",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0014":  {
                   "roleId":  "BR0014",
                   "title":  "Document Control Specialist (US) · BR0014",
                   "jobTitle":  "Document Control Specialist",
                   "department":  "Document Management",
                   "region":  "US",
                   "costCenter":  "114",
                   "description":  "Document Control Specialist in US (Cost Center 114).",
                   "entitlements":  [
                                        "ENT0074",
                                        "ENT0145",
                                        "ENT0001",
                                        "ENT0165",
                                        "ENT0075",
                                        "ENT0118",
                                        "ENT0043",
                                        "ENT0223",
                                        "ENT0181",
                                        "ENT0175",
                                        "ENT0027"
                                    ],
                   "ownerEmployeeId":  "GID0035",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0015":  {
                   "roleId":  "BR0015",
                   "title":  "Document Control Lead (US) · BR0015",
                   "jobTitle":  "Document Control Lead",
                   "department":  "Document Management",
                   "region":  "US",
                   "costCenter":  "115",
                   "description":  "Document Control Lead in US (Cost Center 115).",
                   "entitlements":  [
                                        "ENT0152",
                                        "ENT0109",
                                        "ENT0043",
                                        "ENT0076",
                                        "ENT0047",
                                        "ENT0139",
                                        "ENT0017",
                                        "ENT0126",
                                        "ENT0110",
                                        "ENT0218",
                                        "ENT0200"
                                    ],
                   "ownerEmployeeId":  "GID0027",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0016":  {
                   "roleId":  "BR0016",
                   "title":  "Case Resolution Associate (US) · BR0016",
                   "jobTitle":  "Case Resolution Associate",
                   "department":  "Case Resolution",
                   "region":  "US",
                   "costCenter":  "116",
                   "description":  "Case Resolution Associate in US (Cost Center 116).",
                   "entitlements":  [
                                        "ENT0064",
                                        "ENT0187",
                                        "ENT0119",
                                        "ENT0072",
                                        "ENT0194",
                                        "ENT0009",
                                        "ENT0044",
                                        "ENT0056",
                                        "ENT0121",
                                        "ENT0198",
                                        "ENT0156"
                                    ],
                   "ownerEmployeeId":  "GID0010",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0017":  {
                   "roleId":  "BR0017",
                   "title":  "Case Resolution Specialist (US) · BR0017",
                   "jobTitle":  "Case Resolution Specialist",
                   "department":  "Case Resolution",
                   "region":  "US",
                   "costCenter":  "117",
                   "description":  "Case Resolution Specialist in US (Cost Center 117).",
                   "entitlements":  [
                                        "ENT0201",
                                        "ENT0154",
                                        "ENT0074",
                                        "ENT0198",
                                        "ENT0076",
                                        "ENT0043",
                                        "ENT0165",
                                        "ENT0064",
                                        "ENT0146"
                                    ],
                   "ownerEmployeeId":  "GID0019",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0018":  {
                   "roleId":  "BR0018",
                   "title":  "Case Resolution Lead (US) · BR0018",
                   "jobTitle":  "Case Resolution Lead",
                   "department":  "Case Resolution",
                   "region":  "US",
                   "costCenter":  "118",
                   "description":  "Case Resolution Lead in US (Cost Center 118).",
                   "entitlements":  [
                                        "ENT0007",
                                        "ENT0213",
                                        "ENT0113",
                                        "ENT0085",
                                        "ENT0137",
                                        "ENT0158",
                                        "ENT0094",
                                        "ENT0119",
                                        "ENT0041"
                                    ],
                   "ownerEmployeeId":  "GID0012",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0019":  {
                   "roleId":  "BR0019",
                   "title":  "Risk Monitoring Analyst (US) · BR0019",
                   "jobTitle":  "Risk Monitoring Analyst",
                   "department":  "Risk \u0026 Monitoring",
                   "region":  "US",
                   "costCenter":  "119",
                   "description":  "Risk Monitoring Analyst in US (Cost Center 119).",
                   "entitlements":  [
                                        "ENT0189",
                                        "ENT0152",
                                        "ENT0111",
                                        "ENT0020",
                                        "ENT0143",
                                        "ENT0054",
                                        "ENT0112",
                                        "ENT0062",
                                        "ENT0211",
                                        "ENT0065"
                                    ],
                   "ownerEmployeeId":  "GID0070",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0020":  {
                   "roleId":  "BR0020",
                   "title":  "Risk Monitoring Specialist (US) · BR0020",
                   "jobTitle":  "Risk Monitoring Specialist",
                   "department":  "Risk \u0026 Monitoring",
                   "region":  "US",
                   "costCenter":  "120",
                   "description":  "Risk Monitoring Specialist in US (Cost Center 120).",
                   "entitlements":  [
                                        "ENT0070",
                                        "ENT0037",
                                        "ENT0134",
                                        "ENT0077",
                                        "ENT0034",
                                        "ENT0035",
                                        "ENT0191",
                                        "ENT0087",
                                        "ENT0160",
                                        "ENT0213",
                                        "ENT0022"
                                    ],
                   "ownerEmployeeId":  "GID0039",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0021":  {
                   "roleId":  "BR0021",
                   "title":  "Risk Monitoring Lead (US) · BR0021",
                   "jobTitle":  "Risk Monitoring Lead",
                   "department":  "Risk \u0026 Monitoring",
                   "region":  "US",
                   "costCenter":  "121",
                   "description":  "Risk Monitoring Lead in US (Cost Center 121).",
                   "entitlements":  [
                                        "ENT0141",
                                        "ENT0035",
                                        "ENT0019",
                                        "ENT0202",
                                        "ENT0088",
                                        "ENT0020",
                                        "ENT0225",
                                        "ENT0073",
                                        "ENT0120",
                                        "ENT0002",
                                        "ENT0137"
                                    ],
                   "ownerEmployeeId":  "GID0011",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0022":  {
                   "roleId":  "BR0022",
                   "title":  "Data Quality Analyst (US) · BR0022",
                   "jobTitle":  "Data Quality Analyst",
                   "department":  "Data Quality",
                   "region":  "US",
                   "costCenter":  "122",
                   "description":  "Data Quality Analyst in US (Cost Center 122).",
                   "entitlements":  [
                                        "ENT0132",
                                        "ENT0027",
                                        "ENT0169",
                                        "ENT0057",
                                        "ENT0124",
                                        "ENT0196",
                                        "ENT0006",
                                        "ENT0159",
                                        "ENT0093",
                                        "ENT0183",
                                        "ENT0162"
                                    ],
                   "ownerEmployeeId":  "GID0055",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0023":  {
                   "roleId":  "BR0023",
                   "title":  "Data Quality Specialist (US) · BR0023",
                   "jobTitle":  "Data Quality Specialist",
                   "department":  "Data Quality",
                   "region":  "US",
                   "costCenter":  "123",
                   "description":  "Data Quality Specialist in US (Cost Center 123).",
                   "entitlements":  [
                                        "ENT0008",
                                        "ENT0004",
                                        "ENT0177",
                                        "ENT0066",
                                        "ENT0077",
                                        "ENT0202",
                                        "ENT0210",
                                        "ENT0117",
                                        "ENT0038",
                                        "ENT0169",
                                        "ENT0043"
                                    ],
                   "ownerEmployeeId":  "GID0004",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0024":  {
                   "roleId":  "BR0024",
                   "title":  "Data Quality Lead (US) · BR0024",
                   "jobTitle":  "Data Quality Lead",
                   "department":  "Data Quality",
                   "region":  "US",
                   "costCenter":  "124",
                   "description":  "Data Quality Lead in US (Cost Center 124).",
                   "entitlements":  [
                                        "ENT0196",
                                        "ENT0117",
                                        "ENT0065",
                                        "ENT0105",
                                        "ENT0208",
                                        "ENT0019",
                                        "ENT0112",
                                        "ENT0202",
                                        "ENT0200",
                                        "ENT0039",
                                        "ENT0048"
                                    ],
                   "ownerEmployeeId":  "GID0004",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0025":  {
                   "roleId":  "BR0025",
                   "title":  "Service Operations Coordinator (US) · BR0025",
                   "jobTitle":  "Service Operations Coordinator",
                   "department":  "Payment Operations",
                   "region":  "US",
                   "costCenter":  "125",
                   "description":  "Service Operations Coordinator in US (Cost Center 125).",
                   "entitlements":  [
                                        "ENT0176",
                                        "ENT0173",
                                        "ENT0121",
                                        "ENT0125",
                                        "ENT0076",
                                        "ENT0185",
                                        "ENT0051",
                                        "ENT0007",
                                        "ENT0157"
                                    ],
                   "ownerEmployeeId":  "GID0097",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0026":  {
                   "roleId":  "BR0026",
                   "title":  "Client Account Associate (CA) · BR0026",
                   "jobTitle":  "Client Account Associate",
                   "department":  "Client Accounts",
                   "region":  "CA",
                   "costCenter":  "201",
                   "description":  "Client Account Associate in CA (Cost Center 201).",
                   "entitlements":  [
                                        "ENT0123",
                                        "ENT0175",
                                        "ENT0095",
                                        "ENT0036",
                                        "ENT0169",
                                        "ENT0104",
                                        "ENT0011",
                                        "ENT0150",
                                        "ENT0197",
                                        "ENT0133",
                                        "ENT0007"
                                    ],
                   "ownerEmployeeId":  "GID0109",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0027":  {
                   "roleId":  "BR0027",
                   "title":  "Client Account Specialist (CA) · BR0027",
                   "jobTitle":  "Client Account Specialist",
                   "department":  "Client Accounts",
                   "region":  "CA",
                   "costCenter":  "202",
                   "description":  "Client Account Specialist in CA (Cost Center 202).",
                   "entitlements":  [
                                        "ENT0080",
                                        "ENT0082",
                                        "ENT0067",
                                        "ENT0089",
                                        "ENT0185",
                                        "ENT0006",
                                        "ENT0062",
                                        "ENT0157",
                                        "ENT0193",
                                        "ENT0166",
                                        "ENT0104"
                                    ],
                   "ownerEmployeeId":  "GID0124",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0028":  {
                   "roleId":  "BR0028",
                   "title":  "Client Account Lead (CA) · BR0028",
                   "jobTitle":  "Client Account Lead",
                   "department":  "Client Accounts",
                   "region":  "CA",
                   "costCenter":  "203",
                   "description":  "Client Account Lead in CA (Cost Center 203).",
                   "entitlements":  [
                                        "ENT0140",
                                        "ENT0107",
                                        "ENT0121",
                                        "ENT0134",
                                        "ENT0198",
                                        "ENT0075",
                                        "ENT0036",
                                        "ENT0063",
                                        "ENT0080",
                                        "ENT0147",
                                        "ENT0141"
                                    ],
                   "ownerEmployeeId":  "GID0128",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0029":  {
                   "roleId":  "BR0029",
                   "title":  "Payment Operations Associate (CA) · BR0029",
                   "jobTitle":  "Payment Operations Associate",
                   "department":  "Payment Operations",
                   "region":  "CA",
                   "costCenter":  "204",
                   "description":  "Payment Operations Associate in CA (Cost Center 204).",
                   "entitlements":  [
                                        "ENT0080",
                                        "ENT0156",
                                        "ENT0053",
                                        "ENT0199",
                                        "ENT0132",
                                        "ENT0202",
                                        "ENT0114",
                                        "ENT0175",
                                        "ENT0178",
                                        "ENT0095",
                                        "ENT0026"
                                    ],
                   "ownerEmployeeId":  "GID0030",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0030":  {
                   "roleId":  "BR0030",
                   "title":  "Payment Operations Specialist (CA) · BR0030",
                   "jobTitle":  "Payment Operations Specialist",
                   "department":  "Payment Operations",
                   "region":  "CA",
                   "costCenter":  "205",
                   "description":  "Payment Operations Specialist in CA (Cost Center 205).",
                   "entitlements":  [
                                        "ENT0004",
                                        "ENT0154",
                                        "ENT0030",
                                        "ENT0075",
                                        "ENT0114",
                                        "ENT0131",
                                        "ENT0006",
                                        "ENT0022",
                                        "ENT0027",
                                        "ENT0074",
                                        "ENT0096"
                                    ],
                   "ownerEmployeeId":  "GID0006",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0031":  {
                   "roleId":  "BR0031",
                   "title":  "Payment Operations Lead (CA) · BR0031",
                   "jobTitle":  "Payment Operations Lead",
                   "department":  "Payment Operations",
                   "region":  "CA",
                   "costCenter":  "206",
                   "description":  "Payment Operations Lead in CA (Cost Center 206).",
                   "entitlements":  [
                                        "ENT0128",
                                        "ENT0149",
                                        "ENT0134",
                                        "ENT0117",
                                        "ENT0068",
                                        "ENT0034",
                                        "ENT0153",
                                        "ENT0189",
                                        "ENT0216",
                                        "ENT0196",
                                        "ENT0001"
                                    ],
                   "ownerEmployeeId":  "GID0022",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0032":  {
                   "roleId":  "BR0032",
                   "title":  "Credit Review Associate (CA) · BR0032",
                   "jobTitle":  "Credit Review Associate",
                   "department":  "Credit \u0026 Underwriting",
                   "region":  "CA",
                   "costCenter":  "207",
                   "description":  "Credit Review Associate in CA (Cost Center 207).",
                   "entitlements":  [
                                        "ENT0058",
                                        "ENT0055",
                                        "ENT0120",
                                        "ENT0066",
                                        "ENT0072",
                                        "ENT0173",
                                        "ENT0102",
                                        "ENT0111",
                                        "ENT0181",
                                        "ENT0195",
                                        "ENT0049"
                                    ],
                   "ownerEmployeeId":  "GID0005",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0033":  {
                   "roleId":  "BR0033",
                   "title":  "Credit Review Specialist (CA) · BR0033",
                   "jobTitle":  "Credit Review Specialist",
                   "department":  "Credit \u0026 Underwriting",
                   "region":  "CA",
                   "costCenter":  "208",
                   "description":  "Credit Review Specialist in CA (Cost Center 208).",
                   "entitlements":  [
                                        "ENT0105",
                                        "ENT0058",
                                        "ENT0213",
                                        "ENT0219",
                                        "ENT0160",
                                        "ENT0214",
                                        "ENT0059",
                                        "ENT0111",
                                        "ENT0024"
                                    ],
                   "ownerEmployeeId":  "GID0001",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0034":  {
                   "roleId":  "BR0034",
                   "title":  "Credit Review Lead (CA) · BR0034",
                   "jobTitle":  "Credit Review Lead",
                   "department":  "Credit \u0026 Underwriting",
                   "region":  "CA",
                   "costCenter":  "209",
                   "description":  "Credit Review Lead in CA (Cost Center 209).",
                   "entitlements":  [
                                        "ENT0037",
                                        "ENT0215",
                                        "ENT0065",
                                        "ENT0118",
                                        "ENT0093",
                                        "ENT0130",
                                        "ENT0204",
                                        "ENT0062",
                                        "ENT0220",
                                        "ENT0180",
                                        "ENT0026"
                                    ],
                   "ownerEmployeeId":  "GID0188",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0035":  {
                   "roleId":  "BR0035",
                   "title":  "Portfolio Reporting Analyst (CA) · BR0035",
                   "jobTitle":  "Portfolio Reporting Analyst",
                   "department":  "Portfolio Reporting",
                   "region":  "CA",
                   "costCenter":  "210",
                   "description":  "Portfolio Reporting Analyst in CA (Cost Center 210).",
                   "entitlements":  [
                                        "ENT0090",
                                        "ENT0109",
                                        "ENT0041",
                                        "ENT0037",
                                        "ENT0213",
                                        "ENT0193",
                                        "ENT0185",
                                        "ENT0076",
                                        "ENT0215",
                                        "ENT0132",
                                        "ENT0210"
                                    ],
                   "ownerEmployeeId":  "GID0213",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0036":  {
                   "roleId":  "BR0036",
                   "title":  "Portfolio Reporting Specialist (CA) · BR0036",
                   "jobTitle":  "Portfolio Reporting Specialist",
                   "department":  "Portfolio Reporting",
                   "region":  "CA",
                   "costCenter":  "211",
                   "description":  "Portfolio Reporting Specialist in CA (Cost Center 211).",
                   "entitlements":  [
                                        "ENT0022",
                                        "ENT0014",
                                        "ENT0185",
                                        "ENT0226",
                                        "ENT0008",
                                        "ENT0148",
                                        "ENT0057",
                                        "ENT0066",
                                        "ENT0216",
                                        "ENT0020",
                                        "ENT0153"
                                    ],
                   "ownerEmployeeId":  "GID0079",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0037":  {
                   "roleId":  "BR0037",
                   "title":  "Portfolio Reporting Lead (CA) · BR0037",
                   "jobTitle":  "Portfolio Reporting Lead",
                   "department":  "Portfolio Reporting",
                   "region":  "CA",
                   "costCenter":  "212",
                   "description":  "Portfolio Reporting Lead in CA (Cost Center 212).",
                   "entitlements":  [
                                        "ENT0110",
                                        "ENT0073",
                                        "ENT0037",
                                        "ENT0063",
                                        "ENT0019",
                                        "ENT0121",
                                        "ENT0143",
                                        "ENT0054",
                                        "ENT0153",
                                        "ENT0076",
                                        "ENT0011"
                                    ],
                   "ownerEmployeeId":  "GID0066",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0038":  {
                   "roleId":  "BR0038",
                   "title":  "Document Control Associate (CA) · BR0038",
                   "jobTitle":  "Document Control Associate",
                   "department":  "Document Management",
                   "region":  "CA",
                   "costCenter":  "213",
                   "description":  "Document Control Associate in CA (Cost Center 213).",
                   "entitlements":  [
                                        "ENT0016",
                                        "ENT0063",
                                        "ENT0122",
                                        "ENT0002",
                                        "ENT0223",
                                        "ENT0187",
                                        "ENT0013",
                                        "ENT0186",
                                        "ENT0057",
                                        "ENT0188"
                                    ],
                   "ownerEmployeeId":  "GID0061",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0039":  {
                   "roleId":  "BR0039",
                   "title":  "Document Control Specialist (CA) · BR0039",
                   "jobTitle":  "Document Control Specialist",
                   "department":  "Document Management",
                   "region":  "CA",
                   "costCenter":  "214",
                   "description":  "Document Control Specialist in CA (Cost Center 214).",
                   "entitlements":  [
                                        "ENT0109",
                                        "ENT0182",
                                        "ENT0050",
                                        "ENT0147",
                                        "ENT0090",
                                        "ENT0221",
                                        "ENT0179",
                                        "ENT0075",
                                        "ENT0070",
                                        "ENT0176"
                                    ],
                   "ownerEmployeeId":  "GID0031",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0040":  {
                   "roleId":  "BR0040",
                   "title":  "Document Control Lead (CA) · BR0040",
                   "jobTitle":  "Document Control Lead",
                   "department":  "Document Management",
                   "region":  "CA",
                   "costCenter":  "215",
                   "description":  "Document Control Lead in CA (Cost Center 215).",
                   "entitlements":  [
                                        "ENT0202",
                                        "ENT0027",
                                        "ENT0142",
                                        "ENT0058",
                                        "ENT0040",
                                        "ENT0158",
                                        "ENT0049",
                                        "ENT0087",
                                        "ENT0208",
                                        "ENT0002",
                                        "ENT0053"
                                    ],
                   "ownerEmployeeId":  "GID0034",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0041":  {
                   "roleId":  "BR0041",
                   "title":  "Case Resolution Associate (CA) · BR0041",
                   "jobTitle":  "Case Resolution Associate",
                   "department":  "Case Resolution",
                   "region":  "CA",
                   "costCenter":  "216",
                   "description":  "Case Resolution Associate in CA (Cost Center 216).",
                   "entitlements":  [
                                        "ENT0019",
                                        "ENT0041",
                                        "ENT0058",
                                        "ENT0114",
                                        "ENT0145",
                                        "ENT0108",
                                        "ENT0083",
                                        "ENT0074",
                                        "ENT0016",
                                        "ENT0117"
                                    ],
                   "ownerEmployeeId":  "GID0069",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0042":  {
                   "roleId":  "BR0042",
                   "title":  "Case Resolution Specialist (CA) · BR0042",
                   "jobTitle":  "Case Resolution Specialist",
                   "department":  "Case Resolution",
                   "region":  "CA",
                   "costCenter":  "217",
                   "description":  "Case Resolution Specialist in CA (Cost Center 217).",
                   "entitlements":  [
                                        "ENT0129",
                                        "ENT0004",
                                        "ENT0148",
                                        "ENT0121",
                                        "ENT0196",
                                        "ENT0015",
                                        "ENT0159",
                                        "ENT0053",
                                        "ENT0016",
                                        "ENT0111",
                                        "ENT0212"
                                    ],
                   "ownerEmployeeId":  "GID0105",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0043":  {
                   "roleId":  "BR0043",
                   "title":  "Case Resolution Lead (CA) · BR0043",
                   "jobTitle":  "Case Resolution Lead",
                   "department":  "Case Resolution",
                   "region":  "CA",
                   "costCenter":  "218",
                   "description":  "Case Resolution Lead in CA (Cost Center 218).",
                   "entitlements":  [
                                        "ENT0007",
                                        "ENT0008",
                                        "ENT0150",
                                        "ENT0223",
                                        "ENT0200",
                                        "ENT0111",
                                        "ENT0121",
                                        "ENT0015",
                                        "ENT0077",
                                        "ENT0128"
                                    ],
                   "ownerEmployeeId":  "GID0042",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0044":  {
                   "roleId":  "BR0044",
                   "title":  "Risk Monitoring Analyst (CA) · BR0044",
                   "jobTitle":  "Risk Monitoring Analyst",
                   "department":  "Risk \u0026 Monitoring",
                   "region":  "CA",
                   "costCenter":  "219",
                   "description":  "Risk Monitoring Analyst in CA (Cost Center 219).",
                   "entitlements":  [
                                        "ENT0195",
                                        "ENT0075",
                                        "ENT0104",
                                        "ENT0097",
                                        "ENT0103",
                                        "ENT0086",
                                        "ENT0220",
                                        "ENT0058",
                                        "ENT0047",
                                        "ENT0178"
                                    ],
                   "ownerEmployeeId":  "GID0040",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0045":  {
                   "roleId":  "BR0045",
                   "title":  "Risk Monitoring Specialist (CA) · BR0045",
                   "jobTitle":  "Risk Monitoring Specialist",
                   "department":  "Risk \u0026 Monitoring",
                   "region":  "CA",
                   "costCenter":  "220",
                   "description":  "Risk Monitoring Specialist in CA (Cost Center 220).",
                   "entitlements":  [
                                        "ENT0114",
                                        "ENT0153",
                                        "ENT0025",
                                        "ENT0090",
                                        "ENT0122",
                                        "ENT0085",
                                        "ENT0190",
                                        "ENT0086",
                                        "ENT0016",
                                        "ENT0188",
                                        "ENT0074"
                                    ],
                   "ownerEmployeeId":  "GID0009",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0046":  {
                   "roleId":  "BR0046",
                   "title":  "Risk Monitoring Lead (CA) · BR0046",
                   "jobTitle":  "Risk Monitoring Lead",
                   "department":  "Risk \u0026 Monitoring",
                   "region":  "CA",
                   "costCenter":  "221",
                   "description":  "Risk Monitoring Lead in CA (Cost Center 221).",
                   "entitlements":  [
                                        "ENT0221",
                                        "ENT0136",
                                        "ENT0020",
                                        "ENT0009",
                                        "ENT0150",
                                        "ENT0149",
                                        "ENT0128",
                                        "ENT0076",
                                        "ENT0187",
                                        "ENT0222",
                                        "ENT0100"
                                    ],
                   "ownerEmployeeId":  "GID0024",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0047":  {
                   "roleId":  "BR0047",
                   "title":  "Data Quality Analyst (CA) · BR0047",
                   "jobTitle":  "Data Quality Analyst",
                   "department":  "Data Quality",
                   "region":  "CA",
                   "costCenter":  "222",
                   "description":  "Data Quality Analyst in CA (Cost Center 222).",
                   "entitlements":  [
                                        "ENT0194",
                                        "ENT0136",
                                        "ENT0085",
                                        "ENT0118",
                                        "ENT0062",
                                        "ENT0014",
                                        "ENT0144",
                                        "ENT0097",
                                        "ENT0051",
                                        "ENT0020",
                                        "ENT0116"
                                    ],
                   "ownerEmployeeId":  "GID0017",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0048":  {
                   "roleId":  "BR0048",
                   "title":  "Data Quality Specialist (CA) · BR0048",
                   "jobTitle":  "Data Quality Specialist",
                   "department":  "Data Quality",
                   "region":  "CA",
                   "costCenter":  "223",
                   "description":  "Data Quality Specialist in CA (Cost Center 223).",
                   "entitlements":  [
                                        "ENT0003",
                                        "ENT0187",
                                        "ENT0219",
                                        "ENT0140",
                                        "ENT0173",
                                        "ENT0197",
                                        "ENT0090",
                                        "ENT0054",
                                        "ENT0134",
                                        "ENT0137",
                                        "ENT0007"
                                    ],
                   "ownerEmployeeId":  "GID0001",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0049":  {
                   "roleId":  "BR0049",
                   "title":  "Data Quality Lead (CA) · BR0049",
                   "jobTitle":  "Data Quality Lead",
                   "department":  "Data Quality",
                   "region":  "CA",
                   "costCenter":  "224",
                   "description":  "Data Quality Lead in CA (Cost Center 224).",
                   "entitlements":  [
                                        "ENT0094",
                                        "ENT0110",
                                        "ENT0080",
                                        "ENT0071",
                                        "ENT0031",
                                        "ENT0156",
                                        "ENT0150",
                                        "ENT0145",
                                        "ENT0173",
                                        "ENT0124",
                                        "ENT0040"
                                    ],
                   "ownerEmployeeId":  "GID0001",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0050":  {
                   "roleId":  "BR0050",
                   "title":  "Service Operations Coordinator (CA) · BR0050",
                   "jobTitle":  "Service Operations Coordinator",
                   "department":  "Payment Operations",
                   "region":  "CA",
                   "costCenter":  "225",
                   "description":  "Service Operations Coordinator in CA (Cost Center 225).",
                   "entitlements":  [
                                        "ENT0134",
                                        "ENT0105",
                                        "ENT0062",
                                        "ENT0116",
                                        "ENT0011",
                                        "ENT0202",
                                        "ENT0159",
                                        "ENT0047",
                                        "ENT0079",
                                        "ENT0219",
                                        "ENT0203"
                                    ],
                   "ownerEmployeeId":  "GID0175",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0051":  {
                   "roleId":  "BR0051",
                   "title":  "Client Account Associate (MX) · BR0051",
                   "jobTitle":  "Client Account Associate",
                   "department":  "Client Accounts",
                   "region":  "MX",
                   "costCenter":  "301",
                   "description":  "Client Account Associate in MX (Cost Center 301).",
                   "entitlements":  [
                                        "ENT0154",
                                        "ENT0181",
                                        "ENT0216",
                                        "ENT0085",
                                        "ENT0156",
                                        "ENT0030",
                                        "ENT0083",
                                        "ENT0099",
                                        "ENT0159",
                                        "ENT0080",
                                        "ENT0143"
                                    ],
                   "ownerEmployeeId":  "GID0071",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0052":  {
                   "roleId":  "BR0052",
                   "title":  "Client Account Specialist (MX) · BR0052",
                   "jobTitle":  "Client Account Specialist",
                   "department":  "Client Accounts",
                   "region":  "MX",
                   "costCenter":  "302",
                   "description":  "Client Account Specialist in MX (Cost Center 302).",
                   "entitlements":  [
                                        "ENT0183",
                                        "ENT0131",
                                        "ENT0037",
                                        "ENT0062",
                                        "ENT0150",
                                        "ENT0095",
                                        "ENT0070",
                                        "ENT0164",
                                        "ENT0109",
                                        "ENT0188",
                                        "ENT0042"
                                    ],
                   "ownerEmployeeId":  "GID0056",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0053":  {
                   "roleId":  "BR0053",
                   "title":  "Client Account Lead (MX) · BR0053",
                   "jobTitle":  "Client Account Lead",
                   "department":  "Client Accounts",
                   "region":  "MX",
                   "costCenter":  "303",
                   "description":  "Client Account Lead in MX (Cost Center 303).",
                   "entitlements":  [
                                        "ENT0008",
                                        "ENT0005",
                                        "ENT0077",
                                        "ENT0026",
                                        "ENT0193",
                                        "ENT0017",
                                        "ENT0089",
                                        "ENT0155",
                                        "ENT0052",
                                        "ENT0195"
                                    ],
                   "ownerEmployeeId":  "GID0016",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0054":  {
                   "roleId":  "BR0054",
                   "title":  "Payment Operations Associate (MX) · BR0054",
                   "jobTitle":  "Payment Operations Associate",
                   "department":  "Payment Operations",
                   "region":  "MX",
                   "costCenter":  "304",
                   "description":  "Payment Operations Associate in MX (Cost Center 304).",
                   "entitlements":  [
                                        "ENT0154",
                                        "ENT0142",
                                        "ENT0130",
                                        "ENT0146",
                                        "ENT0139",
                                        "ENT0050",
                                        "ENT0011",
                                        "ENT0034",
                                        "ENT0122",
                                        "ENT0226",
                                        "ENT0137"
                                    ],
                   "ownerEmployeeId":  "GID0090",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0055":  {
                   "roleId":  "BR0055",
                   "title":  "Payment Operations Specialist (MX) · BR0055",
                   "jobTitle":  "Payment Operations Specialist",
                   "department":  "Payment Operations",
                   "region":  "MX",
                   "costCenter":  "305",
                   "description":  "Payment Operations Specialist in MX (Cost Center 305).",
                   "entitlements":  [
                                        "ENT0200",
                                        "ENT0181",
                                        "ENT0101",
                                        "ENT0116",
                                        "ENT0033",
                                        "ENT0155",
                                        "ENT0193",
                                        "ENT0037",
                                        "ENT0011",
                                        "ENT0089",
                                        "ENT0007"
                                    ],
                   "ownerEmployeeId":  "GID0103",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0056":  {
                   "roleId":  "BR0056",
                   "title":  "Payment Operations Lead (MX) · BR0056",
                   "jobTitle":  "Payment Operations Lead",
                   "department":  "Payment Operations",
                   "region":  "MX",
                   "costCenter":  "306",
                   "description":  "Payment Operations Lead in MX (Cost Center 306).",
                   "entitlements":  [
                                        "ENT0053",
                                        "ENT0141",
                                        "ENT0202",
                                        "ENT0010",
                                        "ENT0186",
                                        "ENT0136",
                                        "ENT0026",
                                        "ENT0121",
                                        "ENT0014",
                                        "ENT0149",
                                        "ENT0191"
                                    ],
                   "ownerEmployeeId":  "GID0014",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0057":  {
                   "roleId":  "BR0057",
                   "title":  "Credit Review Associate (MX) · BR0057",
                   "jobTitle":  "Credit Review Associate",
                   "department":  "Credit \u0026 Underwriting",
                   "region":  "MX",
                   "costCenter":  "307",
                   "description":  "Credit Review Associate in MX (Cost Center 307).",
                   "entitlements":  [
                                        "ENT0051",
                                        "ENT0178",
                                        "ENT0071",
                                        "ENT0063",
                                        "ENT0087",
                                        "ENT0065",
                                        "ENT0176",
                                        "ENT0215",
                                        "ENT0125",
                                        "ENT0101",
                                        "ENT0216"
                                    ],
                   "ownerEmployeeId":  "GID0087",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0058":  {
                   "roleId":  "BR0058",
                   "title":  "Credit Review Specialist (MX) · BR0058",
                   "jobTitle":  "Credit Review Specialist",
                   "department":  "Credit \u0026 Underwriting",
                   "region":  "MX",
                   "costCenter":  "308",
                   "description":  "Credit Review Specialist in MX (Cost Center 308).",
                   "entitlements":  [
                                        "ENT0065",
                                        "ENT0028",
                                        "ENT0068",
                                        "ENT0093",
                                        "ENT0034",
                                        "ENT0210",
                                        "ENT0169",
                                        "ENT0003",
                                        "ENT0036",
                                        "ENT0139",
                                        "ENT0006"
                                    ],
                   "ownerEmployeeId":  "GID0255",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0059":  {
                   "roleId":  "BR0059",
                   "title":  "Credit Review Lead (MX) · BR0059",
                   "jobTitle":  "Credit Review Lead",
                   "department":  "Credit \u0026 Underwriting",
                   "region":  "MX",
                   "costCenter":  "309",
                   "description":  "Credit Review Lead in MX (Cost Center 309).",
                   "entitlements":  [
                                        "ENT0173",
                                        "ENT0223",
                                        "ENT0155",
                                        "ENT0106",
                                        "ENT0211",
                                        "ENT0123",
                                        "ENT0035",
                                        "ENT0056",
                                        "ENT0028"
                                    ],
                   "ownerEmployeeId":  "GID0049",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0060":  {
                   "roleId":  "BR0060",
                   "title":  "Portfolio Reporting Analyst (MX) · BR0060",
                   "jobTitle":  "Portfolio Reporting Analyst",
                   "department":  "Portfolio Reporting",
                   "region":  "MX",
                   "costCenter":  "310",
                   "description":  "Portfolio Reporting Analyst in MX (Cost Center 310).",
                   "entitlements":  [
                                        "ENT0084",
                                        "ENT0026",
                                        "ENT0095",
                                        "ENT0082",
                                        "ENT0200",
                                        "ENT0166",
                                        "ENT0083",
                                        "ENT0060",
                                        "ENT0205"
                                    ],
                   "ownerEmployeeId":  "GID0106",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0061":  {
                   "roleId":  "BR0061",
                   "title":  "Portfolio Reporting Specialist (MX) · BR0061",
                   "jobTitle":  "Portfolio Reporting Specialist",
                   "department":  "Portfolio Reporting",
                   "region":  "MX",
                   "costCenter":  "311",
                   "description":  "Portfolio Reporting Specialist in MX (Cost Center 311).",
                   "entitlements":  [
                                        "ENT0189",
                                        "ENT0119",
                                        "ENT0017",
                                        "ENT0105",
                                        "ENT0104",
                                        "ENT0111",
                                        "ENT0137",
                                        "ENT0001",
                                        "ENT0008",
                                        "ENT0036",
                                        "ENT0133"
                                    ],
                   "ownerEmployeeId":  "GID0148",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0062":  {
                   "roleId":  "BR0062",
                   "title":  "Portfolio Reporting Lead (MX) · BR0062",
                   "jobTitle":  "Portfolio Reporting Lead",
                   "department":  "Portfolio Reporting",
                   "region":  "MX",
                   "costCenter":  "312",
                   "description":  "Portfolio Reporting Lead in MX (Cost Center 312).",
                   "entitlements":  [
                                        "ENT0081",
                                        "ENT0067",
                                        "ENT0120",
                                        "ENT0132",
                                        "ENT0185",
                                        "ENT0152",
                                        "ENT0063",
                                        "ENT0212",
                                        "ENT0097",
                                        "ENT0157",
                                        "ENT0182"
                                    ],
                   "ownerEmployeeId":  "GID0003",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0063":  {
                   "roleId":  "BR0063",
                   "title":  "Document Control Associate (MX) · BR0063",
                   "jobTitle":  "Document Control Associate",
                   "department":  "Document Management",
                   "region":  "MX",
                   "costCenter":  "313",
                   "description":  "Document Control Associate in MX (Cost Center 313).",
                   "entitlements":  [
                                        "ENT0128",
                                        "ENT0035",
                                        "ENT0189",
                                        "ENT0018",
                                        "ENT0011",
                                        "ENT0141",
                                        "ENT0086",
                                        "ENT0158",
                                        "ENT0186",
                                        "ENT0178",
                                        "ENT0075"
                                    ],
                   "ownerEmployeeId":  "GID0002",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0064":  {
                   "roleId":  "BR0064",
                   "title":  "Document Control Specialist (MX) · BR0064",
                   "jobTitle":  "Document Control Specialist",
                   "department":  "Document Management",
                   "region":  "MX",
                   "costCenter":  "314",
                   "description":  "Document Control Specialist in MX (Cost Center 314).",
                   "entitlements":  [
                                        "ENT0133",
                                        "ENT0016",
                                        "ENT0014",
                                        "ENT0099",
                                        "ENT0195",
                                        "ENT0219",
                                        "ENT0045",
                                        "ENT0111",
                                        "ENT0156",
                                        "ENT0139"
                                    ],
                   "ownerEmployeeId":  "GID0081",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0065":  {
                   "roleId":  "BR0065",
                   "title":  "Document Control Lead (MX) · BR0065",
                   "jobTitle":  "Document Control Lead",
                   "department":  "Document Management",
                   "region":  "MX",
                   "costCenter":  "315",
                   "description":  "Document Control Lead in MX (Cost Center 315).",
                   "entitlements":  [
                                        "ENT0134",
                                        "ENT0172",
                                        "ENT0085",
                                        "ENT0066",
                                        "ENT0120",
                                        "ENT0059",
                                        "ENT0114",
                                        "ENT0127",
                                        "ENT0170",
                                        "ENT0218"
                                    ],
                   "ownerEmployeeId":  "GID0129",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0066":  {
                   "roleId":  "BR0066",
                   "title":  "Case Resolution Associate (MX) · BR0066",
                   "jobTitle":  "Case Resolution Associate",
                   "department":  "Case Resolution",
                   "region":  "MX",
                   "costCenter":  "316",
                   "description":  "Case Resolution Associate in MX (Cost Center 316).",
                   "entitlements":  [
                                        "ENT0038",
                                        "ENT0217",
                                        "ENT0044",
                                        "ENT0036",
                                        "ENT0212",
                                        "ENT0186",
                                        "ENT0210",
                                        "ENT0182",
                                        "ENT0112",
                                        "ENT0159"
                                    ],
                   "ownerEmployeeId":  "GID0013",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0067":  {
                   "roleId":  "BR0067",
                   "title":  "Case Resolution Specialist (MX) · BR0067",
                   "jobTitle":  "Case Resolution Specialist",
                   "department":  "Case Resolution",
                   "region":  "MX",
                   "costCenter":  "317",
                   "description":  "Case Resolution Specialist in MX (Cost Center 317).",
                   "entitlements":  [
                                        "ENT0103",
                                        "ENT0145",
                                        "ENT0086",
                                        "ENT0101",
                                        "ENT0204",
                                        "ENT0160",
                                        "ENT0003",
                                        "ENT0087",
                                        "ENT0169",
                                        "ENT0024",
                                        "ENT0107"
                                    ],
                   "ownerEmployeeId":  "GID0072",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0068":  {
                   "roleId":  "BR0068",
                   "title":  "Case Resolution Lead (MX) · BR0068",
                   "jobTitle":  "Case Resolution Lead",
                   "department":  "Case Resolution",
                   "region":  "MX",
                   "costCenter":  "318",
                   "description":  "Case Resolution Lead in MX (Cost Center 318).",
                   "entitlements":  [
                                        "ENT0125",
                                        "ENT0013",
                                        "ENT0100",
                                        "ENT0061",
                                        "ENT0126",
                                        "ENT0065",
                                        "ENT0200",
                                        "ENT0124",
                                        "ENT0177",
                                        "ENT0170",
                                        "ENT0158"
                                    ],
                   "ownerEmployeeId":  "GID0032",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0069":  {
                   "roleId":  "BR0069",
                   "title":  "Risk Monitoring Analyst (MX) · BR0069",
                   "jobTitle":  "Risk Monitoring Analyst",
                   "department":  "Risk \u0026 Monitoring",
                   "region":  "MX",
                   "costCenter":  "319",
                   "description":  "Risk Monitoring Analyst in MX (Cost Center 319).",
                   "entitlements":  [
                                        "ENT0032",
                                        "ENT0093",
                                        "ENT0200",
                                        "ENT0043",
                                        "ENT0111",
                                        "ENT0010",
                                        "ENT0201",
                                        "ENT0088",
                                        "ENT0223",
                                        "ENT0132",
                                        "ENT0045"
                                    ],
                   "ownerEmployeeId":  "GID0119",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0070":  {
                   "roleId":  "BR0070",
                   "title":  "Risk Monitoring Specialist (MX) · BR0070",
                   "jobTitle":  "Risk Monitoring Specialist",
                   "department":  "Risk \u0026 Monitoring",
                   "region":  "MX",
                   "costCenter":  "320",
                   "description":  "Risk Monitoring Specialist in MX (Cost Center 320).",
                   "entitlements":  [
                                        "ENT0096",
                                        "ENT0135",
                                        "ENT0075",
                                        "ENT0050",
                                        "ENT0209",
                                        "ENT0130",
                                        "ENT0060",
                                        "ENT0029",
                                        "ENT0179",
                                        "ENT0193",
                                        "ENT0221"
                                    ],
                   "ownerEmployeeId":  "GID0020",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0071":  {
                   "roleId":  "BR0071",
                   "title":  "Risk Monitoring Lead (MX) · BR0071",
                   "jobTitle":  "Risk Monitoring Lead",
                   "department":  "Risk \u0026 Monitoring",
                   "region":  "MX",
                   "costCenter":  "321",
                   "description":  "Risk Monitoring Lead in MX (Cost Center 321).",
                   "entitlements":  [
                                        "ENT0034",
                                        "ENT0005",
                                        "ENT0212",
                                        "ENT0009",
                                        "ENT0063",
                                        "ENT0076",
                                        "ENT0225",
                                        "ENT0194",
                                        "ENT0105",
                                        "ENT0211",
                                        "ENT0053"
                                    ],
                   "ownerEmployeeId":  "GID0077",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0072":  {
                   "roleId":  "BR0072",
                   "title":  "Data Quality Analyst (MX) · BR0072",
                   "jobTitle":  "Data Quality Analyst",
                   "department":  "Data Quality",
                   "region":  "MX",
                   "costCenter":  "322",
                   "description":  "Data Quality Analyst in MX (Cost Center 322).",
                   "entitlements":  [
                                        "ENT0001",
                                        "ENT0123",
                                        "ENT0085",
                                        "ENT0104",
                                        "ENT0058",
                                        "ENT0196",
                                        "ENT0052",
                                        "ENT0090",
                                        "ENT0002",
                                        "ENT0097",
                                        "ENT0152"
                                    ],
                   "ownerEmployeeId":  "GID0243",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0073":  {
                   "roleId":  "BR0073",
                   "title":  "Data Quality Specialist (MX) · BR0073",
                   "jobTitle":  "Data Quality Specialist",
                   "department":  "Data Quality",
                   "region":  "MX",
                   "costCenter":  "323",
                   "description":  "Data Quality Specialist in MX (Cost Center 323).",
                   "entitlements":  [
                                        "ENT0006",
                                        "ENT0125",
                                        "ENT0021",
                                        "ENT0226",
                                        "ENT0079",
                                        "ENT0144",
                                        "ENT0045",
                                        "ENT0166",
                                        "ENT0171",
                                        "ENT0095"
                                    ],
                   "ownerEmployeeId":  "GID0025",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0074":  {
                   "roleId":  "BR0074",
                   "title":  "Data Quality Lead (MX) · BR0074",
                   "jobTitle":  "Data Quality Lead",
                   "department":  "Data Quality",
                   "region":  "MX",
                   "costCenter":  "324",
                   "description":  "Data Quality Lead in MX (Cost Center 324).",
                   "entitlements":  [
                                        "ENT0137",
                                        "ENT0192",
                                        "ENT0212",
                                        "ENT0063",
                                        "ENT0160",
                                        "ENT0002",
                                        "ENT0153",
                                        "ENT0155",
                                        "ENT0085",
                                        "ENT0186",
                                        "ENT0179"
                                    ],
                   "ownerEmployeeId":  "GID0002",
                   "canDecide":  1,
                   "canIam":  0
               },
    "BR0075":  {
                   "roleId":  "BR0075",
                   "title":  "Service Operations Coordinator (MX) · BR0075",
                   "jobTitle":  "Service Operations Coordinator",
                   "department":  "Payment Operations",
                   "region":  "MX",
                   "costCenter":  "325",
                   "description":  "Service Operations Coordinator in MX (Cost Center 325).",
                   "entitlements":  [
                                        "ENT0019",
                                        "ENT0010",
                                        "ENT0217",
                                        "ENT0204",
                                        "ENT0001",
                                        "ENT0226",
                                        "ENT0160",
                                        "ENT0125",
                                        "ENT0104",
                                        "ENT0151",
                                        "ENT0117"
                                    ],
                   "ownerEmployeeId":  "GID0141",
                   "canDecide":  1,
                   "canIam":  0
               }
};
