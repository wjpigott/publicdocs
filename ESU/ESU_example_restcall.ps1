# Sample code and proofs of concept are provided for the purpose of illustration only and are not intended to be used in a production environment.  
# THE SAMPLE CODE AND PROOFS OF CONCEPT ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
# TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE. We grant you a nonexclusive, royalty-free right to use and 
# modify the sample code and to reproduce and distribute the object code form of the sample code, provided that you agree: (i) to not use 
# Microsoft’s name, logo, or trademarks to market your software product in which the sample code is embedded; (ii) to include a valid copyright 
# notice on your software product in which the sample code is embedded; (iii) to provide on behalf of and for the benefit of your subcontractors a 
# disclaimer of warranties, exclusion of liability for indirect and consequential damages and a reasonable limitation of liability;  and (iv) to 
# indemnify, hold harmless, and defend Microsoft, its affiliates  and suppliers from and against any third party claims or lawsuits, including 
# attorneys’ fees, that arise or result from the use or distribution of the sample code.
#
# Define your tenant ID, client ID, and client secret, server is the name of the server to update, esulicensename is from the azure portal Arc ESU license name.
#
#
$tenantId = ""
$clientId = ""
$clientSecret = ""
$subscriptionid = ""
$resourcegroup = ""
$server = ""
$esulicensename = ""
$location = "EastUS"

# Define the resource you want to access
$resource = "https://management.azure.com/"

# Define the token endpoint
$tokenEndpoint = "https://login.microsoftonline.com/$tenantId/oauth2/token"

# Define the body of the request
$body = @{
    'resource' = $resource
    'client_id' = $clientId
    'grant_type' = 'client_credentials'
    'client_secret' = $clientSecret
}

# Invoke the REST method to get the token
$response = Invoke-RestMethod -Method Post -Uri $tokenEndpoint -Body $body

# Extract the token from the response
$token = $response.access_token

# Output the token
$token

# Define the Azure API URL
$url = "https://management.azure.com/subscriptions/$subscriptionid/resourceGroups/$resourcegroup/providers/Microsoft.HybridCompute/machines/$server/licenseProfiles/default?api-version=2023-06-20-preview"

# Create headers with the Authorization token
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$esuBody = @{
    "location" = $location
    "properties" = @{
        "esuProfile" = @{
            "assignedLicense" = "/subscriptions/$subscriptionid/resourceGroups/$resourcegroup/providers/Microsoft.HybridCompute/licenses/$esulicensename"
        }
    }
}

# Convert the request body to JSON format
$bodyJson = $esuBody | ConvertTo-Json

# Make the REST API call
$responseEsu = Invoke-RestMethod -Uri $url -Headers $headers -Method Put -Body $bodyJson
$esuProfile = $responseEsU.properties.esuProfile
$esuProfile