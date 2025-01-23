#                                                                                |
# This script is called from PhoneNumberProvision_Email-Prep.ps1                 |
#                                                                                |
#  Variables referenced from calling script:                                     |
#   Email FROM address                                                           |
#   Email TO address                                                             |
#   Email SUBJECT                                                                |
#   Email MESSAGE                                                                |
#   Access Token for API call                                                    |
# _______________________________________________________________________________|

### Search Azure App Registrations for "CO-OIS-ETI-TeamsAdministration"
    $tenantId = "5711ee8f-5e83-4145-be03-c551134f4160"
    $appId = "fe8f87fa-8fb6-4ead-8879-7db721e0c6f5"
    $appPassword = ".z28Q~LUV2t_cEkjh630OQARKihX22O9yeBxkc49"
  
  $request = @{
          Method = 'POST'
          URI    = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
          body   = @{
              grant_type    = "client_credentials"
              scope         = "https://graph.microsoft.com/.default"
              client_id     = $appId
              client_secret = $appPassword
          }
      }
  # Get the access token
  $token = (Invoke-RestMethod @request).access_token

  $fromAddress = 'Jeff.Hicks@dhs.nj.gov'

  $toAddress =  @(
    @{"emailAddress" = @{"address" = 'Jeff.Hicks@dhs.nj.gov'}}
  )

  $mailSubject = "Test from GitHub" 
  $mailMessage = "Message body..."
  Write-Host "Sending email for Needs Hard Phone action..."

  # Build the Microsoft Graph API request
  $params = @{
    "URI"         = "https://graph.microsoft.com/v1.0/users/$fromAddress/sendMail"
    "Headers"     = @{
      "Authorization" = ("Bearer {0}" -F $token)
    }
    "Method"      = "POST"
    "ContentType" = 'application/json'
    "Body" = (@{
      "message" = @{
        "subject" = $mailSubject
        "body"    = @{
          "contentType" = 'HTML'
          "content"     = $mailMessage
        }
        "toRecipients" = $toAddress
      }
    }) | ConvertTo-JSON -Depth 10
  }

  # Send the message
  Invoke-RestMethod @params -Verbose
