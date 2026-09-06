#!/bin/bash
set -e

# Propagar senales para apagado limpio del servidor
trap 'kill -TERM "$SERVER_PID" 2>/dev/null; wait "$SERVER_PID"' SIGTERM SIGINT

# Arranca el servidor (itzg copia WorldReset.jar a /data/plugins automaticamente)
/start &
SERVER_PID=$!

# Espera a que el servidor este listo y aplica configuracion personalizada
(
    echo "[init-custom] Esperando a que el servidor este disponible..."
    until mc-monitor status --host localhost > /dev/null 2>&1; do
        sleep 3
    done
    sleep 2

    # Desactivar telemetria de WorldReset
    mkdir -p /data/plugins/faststats
    echo "enabled=false" > /data/plugins/faststats/config.properties

    # Desactivar regeneracion natural en los tres mundos de WorldReset
    echo "[init-custom] Aplicando configuracion..."
    rcon-cli execute in game_world run gamerule natural_health_regeneration false
    rcon-cli execute in game_world_nether run gamerule natural_health_regeneration false
    rcon-cli execute in game_world_the_end run gamerule natural_health_regeneration false

    # Mostrar corazones en el Tab
    rcon-cli scoreboard objectives add health health
    rcon-cli scoreboard objectives setdisplay list health
    echo "[init-custom] Listo. Vigilando resets de WorldReset..."

    # Re-aplica la configuracion cada vez que WorldReset genera un mundo nuevo
    tail -n 0 -F /data/logs/latest.log 2>/dev/null | while read -r line; do
        if echo "$line" | grep -q "\\[WorldReset\\] Loaded difficulty from server.properties"; then
            sleep 2
            rcon-cli execute in game_world run gamerule natural_health_regeneration false > /dev/null 2>&1
            rcon-cli execute in game_world_nether run gamerule natural_health_regeneration false > /dev/null 2>&1
            rcon-cli execute in game_world_the_end run gamerule natural_health_regeneration false > /dev/null 2>&1
            rcon-cli scoreboard objectives add health health > /dev/null 2>&1
            rcon-cli scoreboard objectives setdisplay list health > /dev/null 2>&1
            echo "[init-custom] Config re-aplicada tras reset de WorldReset."
        fi
    done
) &

# Espera al proceso del servidor
wait "$SERVER_PID"
