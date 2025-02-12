## Setup env

- OS: Ubuntu 24 LTS
- SGX support: 
```
cat /proc/cpuinfo |grep sgx
```

- Install docker: https://docs.docker.com/engine/install/ubuntu/
  

- Install build env
```
sudo apt-get install build-essential maven
```


- Install openssl 1.1.1
```
cd /tmp/
wget https://www.openssl.org/source/openssl-1.1.1c.tar.gz
tar xvf openssl-1.1.1c.tar.gz
cd openssl-1.1.1c/
./config 
make  -j8
sudo make install -j8
sudo ldconfig
```

- Install openjdk
  ```
  apt install openjdk-21-jdk
  ```

## Build source

```
git submodule init
git submodule update
mvn verify
```

## Build docker image

```
cp Dockerfile ./target/
cd target

```

## Verify using docker-compose
