#!/bin/bash
echo 'Login to ibmcloud'
ibmcloud config --check-version=false -q --http-timeout 240 --color enable
ibmcloud login -r $REGION --apikey $IBM_CLOUD_API_KEY

#SAP Objects with versioning
objectsvskey=$(ibmcloud cos object-versions --bucket $BUCKET_NAME --output text | awk -F'[ \t]+' '/^\/.*/ {print $1}')
objectsvsids=$(ibmcloud cos object-versions --bucket $BUCKET_NAME --output text | awk -F'[ \t]+' '/^\/.*/ {print $2}')

keys=($objectsvskey)     # Convert the space-separated string into an array
ids=($objectsvsids)      # Convert the space-separated string into an array

# Ensure both arrays have the same length
if [ ${#keys[@]} -ne ${#ids[@]} ]; then
    echo "Error: The two lists have different lengths."
    exit 1
fi

for ((i=0; i<${#keys[@]}; i++)); do
    key=${keys[$i]}
    id=${ids[$i]}
    ibmcloud cos object-delete --bucket $BUCKET_NAME --key $key --version-id $id --force
done