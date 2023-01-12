.PHONY: echo,project,registry,service

echo:
	@echo "Usage: make <target>"
	@echo "Targets:"
	@echo "registry - Create a container registry"

project:
	gcloud config set project $(GKE_PROJECT)
	gcloud services enable \
		containerregistry.googleapis.com \
		container.googleapis.com

registry:
	gcloud artifacts repositories create $(GKE_REGISTRY) \
		--project=$(GKE_PROJECT) \
		--repository-format=docker \
		--location=$(GKE_REGION) \
		--description="Docker repository"

cluster:
	gcloud container clusters create $(GKE_CLUSTER) \
		--project=$(GKE_PROJECT) \
		--zone=$(GKE_ZONE)

service:
	gcloud projects add-iam-policy-binding $(GKE_PROJECT) \
		--member=serviceAccount:$(SERVICE_ACCOUNT_EMAIL) \
		--role=roles/container.admin
	gcloud projects add-iam-policy-binding $(GKE_PROJECT) \
		--member=serviceAccount:$(SERVICE_ACCOUNT_EMAIL) \
		--role=roles/storage.admin
	gcloud projects add-iam-policy-binding $(GKE_PROJECT) \
		--member=serviceAccount:$(SERVICE_ACCOUNT_EMAIL) \
		--role=roles/container.clusterViewer

# creds: gcloud iam service-accounts keys create key.json --iam-account=$(SERVICE_ACCOUNT_EMAIL)