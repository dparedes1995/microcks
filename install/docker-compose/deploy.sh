#!/bin/bash

# Obtener el token de autenticación para el servicio de metadatos (IMDSv2)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" 2>/dev/null)

# Obtener la IP pública de la instancia EC2 utilizando el token
EC2_PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)

# Verificar que la IP pública se obtuvo correctamente
if [ -z "$EC2_PUBLIC_IP" ]; then
    echo "Error: No se pudo obtener la IP pública del EC2."
    exit 1
fi

echo "La IP pública del EC2 es: $EC2_PUBLIC_IP"

# Reemplazar 'localhost' con la IP pública en el archivo docker-compose.yml
sed -i "s/localhost/$EC2_PUBLIC_IP/g" docker-compose.yml

# Levantar los servicios con docker-compose
docker compose up -d
