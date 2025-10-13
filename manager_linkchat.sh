#!/bin/bash
# manage_linkchat.sh — Script maestro para LinkChat (build / run)

IMAGE_NAME="linkchat"
NETWORK_NAME="hostonly_net"
PARENT_IFACE="vmnet1"
SUBNET="172.16.242.0/24"
GATEWAY="172.16.242.1"

# Función: Construir imagen
build_image() {
    echo "Eliminando imagen anterior ($IMAGE_NAME)..."
    sudo docker rmi -f $IMAGE_NAME 2>/dev/null || echo "No había imagen previa."


    echo "Construyendo nueva imagen ($IMAGE_NAME)..."   
    sudo docker build -t $IMAGE_NAME .

    if [ $? -eq 0 ]; then
        echo "Imagen '$IMAGE_NAME' construida correctamente."
    else
        echo "Error al construir la imagen."
        exit 1
    fi
}

#Función: Crear red si no existe
ensure_network() {
    if ! sudo docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
        echo "La red '$NETWORK_NAME' no existe. Creándola..."
        sudo docker network create -d macvlan \
            -o parent="$PARENT_IFACE" \
            --subnet="$SUBNET" \
            --gateway="$GATEWAY" \
            "$NETWORK_NAME"
        echo "Red '$NETWORK_NAME' creada correctamente."
    else
        echo "Red '$NETWORK_NAME' detectada."
    fi
}

run_container() {
    ensure_network

    CONTAINER_NAME="linkchat_node_$(date +%H%M%S)"
    echo "Iniciando contenedor '$CONTAINER_NAME'..."

    sudo docker run -it --rm \
        --name "$CONTAINER_NAME" \
        --network "$NETWORK_NAME" \
        --cap-add=NET_RAW \
        --cap-add=NET_ADMIN \
        "$IMAGE_NAME"
}

#Menú de comandos
case "$1" in
    build)
        build_image
        ;;
    run)
        run_container
        ;;
    *)
        echo "Uso: $0 {build|run}"
        echo
        echo "  build  → Reconstruye la imagen linkchat desde cero"
        echo "  run    → Ejecuta un contenedor linkchat en la red host-only"
        exit 1
        ;;
esac
