DIR=`pwd`

m_error() {
  echo $1
  exit 2
}

install_go() {
  cd ${DIR}
  if [ ! -f go1.13.linux-amd64.tar.gz ]; then
   if ! wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz; then
     m_error "Unable to download Go lang 1.13 from Google!"
   fi
  fi
  if [ ! -d ${DIR}/go ]; then
    tar xvfz go1.13.linux-amd64.tar.gz
  fi
}

install_pronlex() {
  cd ${DIR}
  if [ ! -d src ]; then
    mkdir src
  fi
  cd src
  if [ ! -d pronlex ]; then
    if ! git clone https://github.com/stts-se/pronlex.git; then
      m_error "Failed to clone Pronlex from git repo!"
    fi
    cd pronlex
  else
    cd pronlex
    git pull
  fi
  if ! go build ./...; then
    m_error "Failed to build Pronlex!"
  fi

  # todo download testdata and test pronlex

  if [ -d ${DIR}/appdir ]; then
    rm -rf ${DIR}/appdir
  fi
  cd ${DIR}/src/pronlex/install
  /bin/bash setup.sh ${DIR}/appdir
  if [ -d ${DIR}/src/lexdata ]; then
    cd ${DIR}/src/lexdata
    if ! git pull; then
      m_error "Unable to update lexdata from git repo"
    fi
    cd ${DIR}/src/pronlex/install
  fi

  /bin/bash import.sh ${DIR}/src/lexdata ${DIR}/appdir master

  echo "Starting Pronlex server. Will wait a minute for it to start up and download any dependencies, and then kill it."
  /bin/bash start_server.sh -a ${DIR}/appdir -p 8080 &
  PRONLEX_PID=$!
  for i in $(seq 1 6); do
    sleep 10
    echo "${i}0/60 seconds slept before killing server..."
  done
  kill ${PRONLEX_PID}
}


if [ ! -d ${DIR}/go ]; then
  install_go
fi

export GOROOT=${DIR}/go
export GOPATH=${DIR}/goProjects
export PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}

install_pronlex

echo "Successfully prepared Pronlex! Now run ./build.sh"
