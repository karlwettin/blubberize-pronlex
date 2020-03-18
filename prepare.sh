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
  mkdir src
  cd src
  if ! git clone https://github.com/stts-se/pronlex.git; then
    m_error "Failed to clone Pronlex from git repo!"
  fi
  cd pronlex
  if ! go build ./...; then
    m_error "Failed to build Pronlex!"
  fi
  # todo download testdata and test pronlex
  cd install
  /bin/bash setup.sh ${DIR}/appdir
  /bin/bash import.sh ${DIR}/src/lexdata ${DIR}/appdir
}


if [ ! -d ${DIR}/go ]; then
  install_go
fi

export GOROOT=${DIR}/go
export GOPATH=${DIR}/goProjects
export PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}

if [ ! -d src ]; then
  install_pronlex
fi

