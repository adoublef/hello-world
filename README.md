# Hello World using K8S

From the official docs [link](https://cloud.google.com/community/tutorials/telepresence-and-gke)

[Deploy](https://cloud.google.com/kubernetes-engine/docs/quickstarts/deploy-app-container-image)

To build from a Dockerfile you can use the following command `docker build . -t hello-world`

To run the dockerfile `docker run -p 80:80 -d hello-world:latest`

To upload to docker registry I must do the following ``

## Kubernetes

A deployment/service file is required to be made.

### Secrets

I may need to use [this](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) for images that require a secret `kubectl create secret docker-registry regcred --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>`

## Google Cloud

This will set the default project to the current application
CMD to follow `gcloud config set project PROJECT_ID`

### Create a cluster

A cluster consists of at least one cluster control plane machine and multiple worker machines called nodes. Nodes are Compute Engine virtual machine (VM) instances that run the Kubernetes processes necessary to make them part of the cluster. You deploy applications to clusters, and the applications run on the nodes.

London is `europe-west2-a`

CMD is `gcloud container clusters create-auto hello-world-cluster --region europe-west2`

This command configures kubectl to use the cluster you created.

Store docker image [here](https://cloud.google.com/artifact-registry/docs/docker/store-docker-container-images)

If using docker [here](https://cloud.google.com/kubernetes-engine/docs/tutorials/hello-app)

CMD is `gcloud container clusters get-credentials hello-world-cluster \
    --region europe-west2`

```bash
kubeconfig entry generated for hello-world-cluster.
NAME                 LOCATION      MASTER_VERSION  MASTER_IP     MACHINE_TYPE  NODE_VERSION    NUM_NODES  STATUS
hello-world-cluster  europe-west2  1.24.7-gke.900  34.89.91.128  e2-medium     1.24.7-gke.900  2          RUNNING
```

Build gke docker container using `docker build -t europe-west2-docker.pkg.dev/${PROJECT_ID}/hello-world/hello-app:v1 .`

Comprehensive rules [Link](https://cloud.google.com/kubernetes-engine/docs/tutorials/hello-app#cloud-shell_2)

[Artifacts](https://console.cloud.google.com/artifacts?project=hello-world-374423)

### Steps

1. Create Application
1. Push to Docker Hub
1. Create Google Cloud repository
1. Push from Docker Hub to Google Artifact Registry
1. Create GKE Cluster
1. Deploy image to Cluster (using yaml files)

### Terraform

Let's see if this cleans things up [here](https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke)

### SSL

Country Name = GB
State = England
City = London

### Deployemnt

Warning: Autopilot set default resource requests for Deployment default/hello-world-deployment, as resource requests were not specified. See <http://g.co/gke/autopilot-defaults>

### Update

to update `kubectl set image deployment/hello-world-deployment hello-world-app=europe-west2-docker.pkg.dev/hello-world-374423/hello-world-docker/hello-world-app:v2`

To watch `watch kubectl get ingress,pods,services,deployment`

[Deploy via Github Actions](https://www.youtube.com/watch?v=6dLHcnlPi_U)

[GIthub actions](https://docs.github.com/en/actions/deployment/deploying-to-your-cloud-provider/deploying-to-google-kubernetes-engine)

## GCloud

Create Artifact Registry

```bash
gcloud artifacts repositories create $GKE_REGISTRY \
    --project=$GKE_PROJECT \
    --repository-format=docker \
    --location=$GKE_REGION \
    --description="Docker repository"
```

Create Cluster

```bash
 gcloud container clusters create $GKE_CLUSTER \
	--project=$GKE_PROJECT \
	--region=$GKE_REGION
```