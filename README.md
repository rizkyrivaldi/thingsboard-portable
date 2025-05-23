# thingsboard-portable
Portable thingsboard using docker, easy to install, move, and backup. Tested on Ubuntu 24.04

## Dependency Installation Guide
### Dependency
Install required dependecy
```
sudo update
sudo apt upgrade
sudo apt install make zip unzip
```

### Install Docker
Install docker using the available script
```
sudo chmod +x install_docker.sh
./install_docker.sh
```

## Thingsboard Installation Guide
### Installation without backup file
Install thingsboard for the first time:
```
make install
```

### Installation WITH backup file
Install thingsboard if there is backup file available
```
make install-from-backup
```

## Start and Stop Thingsboard
To start thingsboard:
```
make start
```

To stop thingsboard:
```
make stop
```

### Backup Guide
To backup the thingsboard instance:
```
make backup
```
There will be backup.zip file generated, use this file to move all Thingsboard instance to other machine