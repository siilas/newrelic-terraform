# Newrelic Terraform #

*Just a test creating New Relic alerts with Terraform.*

### Useful links ###

* [Getting started with New Relic and Terraform](https://developer.newrelic.com/automate-workflows/get-started-terraform)

### Runnning ###

Firts of all, you need to set the environment variables:
```
export NEW_RELIC_ACCOUNT_ID={Your New Relic account ID}
export NEW_RELIC_API_KEY={Your New Relic API Key, type = USER}
```

To get things started, run:
```
terraform init
```

Then, run:
```
terraform plan
```

And finally, apply the changes:
```
terraform apply
```
