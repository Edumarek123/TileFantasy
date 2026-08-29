import os
from dotenv import load_dotenv

load_dotenv()


TOKEN_ALGORITHM = os.getenv("TOKEN_ALGORITHM")
SECRET_KEY = os.getenv("SECRET_KEY")
GAME_KEY = os.getenv("GAME_KEY")
GAME_VERSION = os.getenv("GAME_VERSION")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES"))