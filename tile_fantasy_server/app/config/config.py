import os
from dotenv import load_dotenv

load_dotenv()


def require_env(name: str) -> str:
    value = os.getenv(name)

    if not value:
        raise RuntimeError(f"Missing environment variable: {name}")

    return value


#----------------#Token#----------------#
TOKEN_ALGORITHM = os.getenv("TOKEN_ALGORITHM", "HS256")
SECRET_KEY = require_env("SECRET_KEY")
GAME_KEY = require_env("GAME_KEY")
GAME_VERSION = require_env("GAME_VERSION")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "60"))

# HS256 com chave curta permite forjar tokens por forca bruta
if len(SECRET_KEY) < 32:
    raise RuntimeError("SECRET_KEY must have at least 32 characters. Generate one with: python -c \"import secrets; print(secrets.token_urlsafe(48))\"")


#----------------#Database#----------------#
DB_USER = require_env("DB_USER")
DB_PASSWORD = require_env("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST", "host.docker.internal")
DB_PORT = int(os.getenv("DB_PORT", "3306"))
DB_DATABASE = os.getenv("DB_DATABASE", "tile_fantasy_db")
