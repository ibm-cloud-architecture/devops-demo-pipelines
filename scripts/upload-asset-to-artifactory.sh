apt-get install -y jq curl
filepath=./ci/assets/default-kabanero-pipelines.tar.gz
checksum_256=$(shasum -a 256 ./$filepath | grep -Eo '^[^ ]+' )
checksum_1=$(shasum -a 1 ./$filepath | grep -Eo '^[^ ]+' )
echo $checksum_256 > 256.txt
echo $checksum_1 > 1.txt
filename=default-kabanero-pipelines
artifactory_repo_path="https://artifactory-tools.devops-gse-state-288036-0143c5dd31acd8e030a1d6e0ab1380e3-0000.tor01.containers.appdomain.cloud/artifactory/pipeline-server"
curl -H X-Checksum-Sha1:${checksum_1} -H X-Checksum-Sha256:${checksum_256} -H "X-JFrog-Art-Api:$api_key" -X PUT "$artifactory_repo_path/$filename-$PIPELINE_VERSION.tar.gz" -T $filepath