## Donate could power GoFundMe, and it is simple.

The idea for Donate came from a Systems Design interview. The
paragraphs below are the only part of this system that was
not original, but copied, adapted, inherited (or similar) from the
interviw.

### Design a web-based system for running an online charity campaign.

Parameters of the system:
 - The users should be able to make contributions in the amount of $10, $25, $50, $100
 - The users have to provide their email address and they get an email receipt
 - Fixed funding goal: raise $100M over 5 days. Once the goal is reached, the campaign should end
 - The website should show in real-time how much has been raised so far and how much time is left for the campaign
 - Credit or debit card payments are accepted. For processing the payment a 3rd-party service such as Stripe or Paypal is used which provides following an API to request that a certain amount to be charged for that payment method

```
 USERS
 uID, email, preferedPyment


 PAYMENTS_TABLE
 uID, secret


 MONEY
 uID, campaingID, amount, myGeneratedID, processorTransactionID, processorID


 CAMPAIGNS
 cID, user_owner, current_total, goal_amount


 while current_total < goal_amount:
    # donacion was made
    # Process transaction
    # receipt email
#Thanks note


Verb Parameters

listCampaigns None
listCampaigns campaign_namen # https:/site.com/campagns/345

makeDonation campaignID, uID, amount (prefered[myGeneratedID]
```