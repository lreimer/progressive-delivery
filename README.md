# Progressive Delivery with OpenFeature and Keptn

Progressive delivery workshop for OpenFeature and Keptn

```bash
# create empty GKE cluster
make create-gke-cluster

# install ArgoCD in your cluster
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s

# get the initial password
argocd admin initial-password -n argocd

# build and run the demo app
npm install
node index.js

# build and push docker images for demo app
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 --push --tag lreimer/featuredemo:v1.1 .
```

## Maintainer

M.-Leander Reimer (@lreimer), <mario-leander.reimer@qaware.de>

## License

This software is provided under the MIT open source license, read the `LICENSE`
file for details.
