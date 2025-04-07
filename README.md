# Docker Swarm Setup 🐳

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/)

Guia para configurar um cluster Docker Swarm com serviços escaláveis e balanceamento de carga.

---

## **Índice**
1. [Visão Geral](#visão-geral)
2. [Pré-requisitos](#pré-requisitos)
3. [Passo a Passo](#passo-a-passo)
4. [Comandos Úteis](#comandos-úteis)
5. [Estrutura de Arquivos](#estrutura-de-arquivos)
6. [Exemplo de Configurações](#exemplo-de-configurações)
7. [Troubleshooting](#troubleshooting)
8. [Contribuição](#contribuição)
9. [Licença](#licença)

---

## **Visão Geral**
Este projeto demonstra como configurar um cluster Docker Swarm para:
- Gerenciar múltiplos nós (máquinas).
- Implantar serviços escaláveis (como NGINX).
- Configurar balanceamento de carga automático.

---

## **Pré-requisitos**
- **Docker Engine** instalado em todas as máquinas (versão 20.10+).
- **Conectividade de rede** entre os nós:
  - Portas abertas: `2377/tcp`, `7946/tcp/udp`, `4789/udp`.
- Arquivos de configuração:
  - `nginx-swarm.yml` (serviço web).
  - `autoscaler.yml` (escalabilidade automática).

---

## **Passo a Passo**

### 1. Inicializar o Cluster Swarm
```bash
# No nó gerenciador:
sudo docker swarm init --advertise-addr <IP_DO_GERENTE>
# Exemplo:
sudo docker swarm init --advertise-addr 192.168.1.100
```
### 2. Adicionar Nós Trabalhadores
```bash
# Execute o comando gerado pelo 'swarm init' nos workers:
docker swarm join --token <TOKEN> <IP_GERENTE:2377>
```
### 3. Verificar Nós
```bash
docker node ls
```
### 4. Implantar Serviços 
```bash
# Stack NGINX
docker stack deploy -c nginx-swarm.yml nginx-stack

# Stack Autoscaler
docker stack deploy -c autoscaler.yml autoscaler-stack
```
### 5. Verificar Serviços
```bash
 docker service ls
```
### Comandos Úteis  
```bash
Escalar serviço	
docker service scale <SERVIÇO>=<NÚMERO>

Atualizar serviço	
docker service update --image <IMAGEM> <SERVIÇO>

Ver logs do serviço	
docker service logs <SERVIÇO>

Remover stack	
docker stack rm <NOME_DA_STACK>

Sair do Swarm	
docker swarm leave --force
```
### Exemplo de nginx-swarm.yml 
```bash
version: '3.8'
services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
    deploy:
      replicas: 3
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure
```
### Troubleshooting  

    Erro: "This node is not a swarm manager" 
    Execute docker swarm init no nó gerenciador. 

    Nó não aparece em docker node ls 
    Verifique o token e a conectividade de rede. 

    Serviço não inicia 
    Use docker service ps <SERVIÇO> para debugar. 
    
### Licença  

Este projeto está sob licença MIT .
Copyright (c) 2024 Seu Nome.   

```bash

### **Como usar**:
1. Substitua `<IP_DO_GERENTE>` pelo IP real do seu nó gerenciador.
2. Personalize os arquivos YAML conforme sua necessidade.
3. Inclua o script `setup-swarm.sh` (fornecido anteriormente) para automação.
```
     
