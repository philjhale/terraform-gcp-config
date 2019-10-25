# terraform-gcp-config

A reminder of the basic steps require to run Terraform on GCP.

## Pre-requisites

- A Mac
- gcloud SDK
- gsutil
- Homebrew
- A Google account

## Steps

Install all the requirements. Google Cloud SDK [also installs gsutil](https://cloud.google.com/storage/docs/gsutil_install).

```
brew cask install google-cloud-sdk
brew install terraform
```

Log into your Google account.
```
gcloud init
```

Create a new project. There are multiple ways to do this:
- Using `gcloud init` provides an option to create a project
- Create using the [Cloud Console](https://console.cloud.google.com)
- Run `gcloud projects create [your-project-name]`

Set a variable so the project name can be used in the commands below.
```
GOOGLE_PROJECT_ID=[your-project-id]
```

Create a Service Account to execute Terraform code.
```
gcloud iam service-accounts create terraform --display-name=Terraform
```

Give the Terraform Service Account the required permissions on your project.
```
gcloud projects add-iam-policy-binding $GOOGLE_PROJECT_ID \
  --member serviceAccount:terraform@$GOOGLE_PROJECT_ID.iam.gserviceaccount.com \
  --role roles/owner
```

Generate a key for the Terraform Service Account.
```
gcloud iam service-accounts keys create ./terraform-key.json \
  --iam-account terraform@$GOOGLE_PROJECT_ID.iam.gserviceaccount.com
```

You must link your project to a billing account before a storage bucket can be created. To do this manually go to the [billing section](https://console.cloud.google.com/billing/) of the Cloud Console. 

Create a bucket with Bucket Policy Only on to store Terraform state.
```
gsutil mb -b on -p $GOOGLE_PROJECT_ID gs://${GOOGLE_PROJECT_ID}_terraform
```

Initialise Terraform.
```
export GOOGLE_CLOUD_KEYFILE_JSON=./terraform-key.json
terraform init -backend-config=bucket=${GOOGLE_PROJECT_ID}_terraform
```

Execute the Terraform code.
```
terraform apply
```
