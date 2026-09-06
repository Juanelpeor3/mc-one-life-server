# mc-one-life-server

Dockerized Minecraft **"One Life"** server. If **any player dies**, the world resets instantly with a new seed thanks to [WorldReset](https://modrinth.com/plugin/worldreset), without restarting the server.

Servidor de Minecraft **"One Life"** dockerizado. Si **cualquier jugador muere**, el mundo se resetea al instante con una nueva seed gracias a [WorldReset](https://modrinth.com/plugin/worldreset), sin necesidad de reiniciar el servidor.

## How it works / Como funciona

1. The server runs in **Hardcore** mode with natural regeneration disabled across all three worlds (overworld, nether, end).
2. **WorldReset** detects a player death and instantly generates a new world with a random seed.
3. An **entrypoint wrapper** automatically re-applies gamerules and the scoreboard every time WorldReset generates a new world.
4. The **Tab** list shows each online player's hearts.

---

1. El servidor corre en modo **Hardcore** con regeneracion natural desactivada en los tres mundos (overworld, nether, end).
2. **WorldReset** detecta la muerte de un jugador y genera un mundo nuevo con una seed aleatoria al instante.
3. Un **entrypoint wrapper** re-aplica automaticamente los gamerules y el scoreboard cada vez que WorldReset genera un mundo nuevo.
4. En el **Tab** se muestran los corazones de cada jugador conectado.

## Requirements / Requisitos

- [Docker](https://docs.docker.com/get-docker/) & Docker Compose

## Installation / Instalacion

```bash
git clone https://github.com/Juanelpeor3/mc-one-life-server.git
cd mc-one-life-server

# Copy the example and edit your values / Copia el ejemplo y edita tus valores
cp .env.example .env
```

## Configuration / Configuracion

Edit the `.env` file with your values / Edita el archivo `.env` con tus valores:

| Variable              | Description / Descripcion                          | Default  |
|-----------------------|----------------------------------------------------|----------|
| `VERSION`             | Minecraft version / Version de Minecraft           | `LATEST` |
| `RCON_PASSWORD`       | RCON password (required) / Contraseña RCON         | -        |
| `WHITELIST`           | Allowed players, comma-separated / Jugadores       | -        |
| `OPS`                 | Server admins / Administradores                    | -        |
| `VIEW_DISTANCE`       | Render distance in chunks / Distancia de render    | `16`     |
| `SIMULATION_DISTANCE` | Simulation distance in chunks / Distancia de sim.  | `10`     |
| `INIT_MEMORY`         | Initial JVM memory / Memoria inicial JVM           | `4G`     |
| `MAX_MEMORY`          | Max JVM memory / Memoria maxima JVM                | `6G`     |

## Usage / Uso

```bash
# Start the server / Arrancar el servidor
docker compose up -d

# Watch logs / Ver logs en tiempo real
docker compose logs -f

# Stop the server / Detener el servidor
docker compose down
```

Once in-game, enable death reset as OP / Una vez dentro, activa el reset por muerte como OP:

```
/wr death
```

## Project structure / Estructura del proyecto

```
.
├── Dockerfile                 # Image based on itzg/minecraft-server
├── docker-compose.yml         # Service configuration
├── entrypoint-wrapper.sh      # Gamerules, scoreboard & reset watcher
├── plugins/
│   └── WorldReset-1.7.jar     # Plugin that resets the world on death
├── .env.example               # Environment variables template
└── .env                       # Your local config (not tracked by git)
```

## License / Licencia

[MIT](LICENSE)
