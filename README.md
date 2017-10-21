# Blockchain Mortgae Bond Registry

> Contest project for hackathon "Blockchain - the New Oil of Russia", Kazan, August 27-29, 2017

![](https://github.com/BankEx/Blockchain-Hackathon-Kazan/blob/master/Images/BankEx.jpg?raw=true)

![](https://github.com/BankEx/Blockchain-Hackathon-Kazan/blob/master/Images/BankEx-2.jpg?raw=true)

## Online Demo
[https://hackathon.bankexlab.com](https://hackathon.bankexlab.com)

## Contracts

```bash
cd contracts/
```

## Web App

```bash
сd webapp/
```
### Running using Node.JS

#### Prerequisites

* Node/NPM install https://github.com/creationix/nvm

#### Running

```bash
npm install
npm start
```

Webapp will be available at ```http://localhost:3000```

### Running using Docker

#### Prerequisites

* Install Docker https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-getting-started
* Install Docker Compose https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-16-04

#### Starting

```bash
docker-compose up -d
```

Webapp will be available at ```http://localhost:3000```

#### Stopping

```bash
docker-compose down
```