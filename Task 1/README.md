
To apply kubernetes deployment file to cluster, use below command:

kubectl apply -f hishab-welcomeapp-deployment-with-service.yaml


Before applying deployment manifest, have to ensure below things depanding on the manifest file:
 1. Create PV for shared storage
 2. Create PVC
