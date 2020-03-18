DIR=`pwd`

export GOROOT=${DIR}/go
export GOPATH=${DIR}/goProjects
export PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}

cd ${DIR}/src/pronlex/install
/bin/bash start_server.sh -a ${DIR}/appdir -p 8787
