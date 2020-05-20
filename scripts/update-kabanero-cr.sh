# install packages
apt-get install -y jq

oc project kabanero

oc get kabanero -o json > ./json/kabanero.json
echo "here is the json file"
cat ./json/kabanero.json
echo "here is the end"

base_url=https://artifactory-tools.devops-gse-state-288036-0143c5dd31acd8e030a1d6e0ab1380e3-0000.tor01.containers.appdomain.cloud/artifactory/pipeline-server/
filename=default-kabanero-pipelines-
host_url=$base_url$filename$PIPELINE_VERSION.tar.gz
# echo $host_url
name_of_pipeline=testing_pipeline-2
tar_file_name=default-kabanero-pipelines.tar.gz

# generate sha256 on the zip file
# get_sha=$(shasum -a 256 ./$tar_file_name | grep -Eo '^[^ ]+' )
get_sha=$(cat ./256.txt | head -n 1)

# echo "sha256 value: " $get_sha

# add double quotes to the sha256
new_sha=\"${get_sha}\"

# get the add_pipeline_template.json and replace the url, id and sha256 values and store it in another file
jq '.https.url="'$host_url'" | .id="'$name_of_pipeline'" | .sha256="'$get_sha'"' ./json/add_pipeline_template.json > ./json/add_pipeline_modified_template.json


# cat ./json/add_pipeline_modified_template.json

# Get the number of pipelines we currently have on the kabanero CR and increment by 1

num_of_pipelines=$(jq '.items[].spec.stacks.pipelines | length' ./json/kabanero.json)

# echo $num_of_pipelines

# add the add_pipeline_modified_template.json to the kabanero.json file
jq '.items[].spec.stacks.pipelines['$num_of_pipelines']='"$(cat ./json/add_pipeline_modified_template.json)"'' ./json/kabanero.json | json_pp

# prettify and store the result in another file
# echo $result | json_pp > ./json/kabanero-2.json

# cat ./json/kabanero.json

oc delete kabanero kabanero
# apply your new changes to the kabanero custom resource
oc apply -f ./json/kabanero.json
