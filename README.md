## prepare.sh

* Clones (or pulls existing) repositories to `./src`
* Installs databases
* Downloads Go lang 1.13 if not already downloaded
* Extracts Go lang

## build.sh

* Creates the Docker image from Blubber YAML.

## run.sh

* Starts the Docker image on local Docker.

## Regading insecurity of Blubber

This is an insecure Blubber service. It might not have to be. 
Uncertain what's written to disk (database locks etc), which is the reason for leaving it unsecure. 
