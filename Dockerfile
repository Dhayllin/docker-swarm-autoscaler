FROM docker:cli

# Copia o script para o container
COPY autoscaler.sh /autoscaler.sh

# Dá permissão de execução
RUN chmod +x /autoscaler.sh

# Instala bash e bc (bc é pra fazer cálculos)
RUN apk add --no-cache bash bc

# Comando para rodar
CMD ["bash", "/autoscaler.sh"]
