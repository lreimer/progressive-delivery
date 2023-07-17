# https://app.electricitymaps.com/map?lang=de
# https://cloud.google.com/compute/docs/regions-zones?hl=de#available
GCP_PROJECT ?= cloud-native-experience-lab
GCP_REGION ?= europe-north1
GCP_ZONE ?= europe-north1-b

prepare-gke-cluster:
	@gcloud config set compute/region europe-west1
	@gcloud config set compute/zone europe-west1-b
	@gcloud config set container/use_client_certificate False

create-gke-cluster:
	@gcloud container clusters create progressive-delivery \
		--release-channel=regular \
		--cluster-version=1.26 \
		--region=$(GCP_REGION) \
		--addons HttpLoadBalancing,HorizontalPodAutoscaling \
		--workload-pool=$(GCP_PROJECT).svc.id.goog \
		--num-nodes=3 \
		--min-nodes=3 --max-nodes=5 \
		--enable-autoscaling \
		--autoscaling-profile=optimize-utilization \
		--enable-vertical-pod-autoscaling \
		--machine-type=e2-medium \
		--logging=SYSTEM \
    	--monitoring=SYSTEM
	@kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$$(gcloud config get-value core/account)
	@kubectl cluster-info

delete-clusters: delete-gke-cluster

delete-gke-cluster:
	@gcloud container clusters delete progressive-delivery --region=$(GCP_REGION) --async --quiet
