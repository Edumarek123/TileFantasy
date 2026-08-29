from fastapi import HTTPException
from datetime import datetime, timedelta, timezone
from jose import jwt, JWTError
from app.config.config import GAME_VERSION, GAME_KEY, TOKEN_ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES,SECRET_KEY

#----------------#Token#----------------#
def create_access_token(username: str):
    expire = datetime.now(timezone.utc) + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

    payload = {"username": username, "exp": expire, "secret": GAME_KEY, "version" : GAME_VERSION}

    return jwt.encode(payload, SECRET_KEY, algorithm=TOKEN_ALGORITHM)


def verify_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[TOKEN_ALGORITHM])

        username = payload.get("username")
        secret = payload.get("secret")
        version = payload.get("version")

        if secret != GAME_KEY:
            raise HTTPException(status_code=400, detail="Credential Invalid.")

        if version != GAME_VERSION:
            raise HTTPException(status_code=426, detail="Please Update the game.")

        if username is None: #talvez consultar nos ja conhecidos
            raise HTTPException(status_code=401, detail="Invalid token.")

        return username

    except JWTError:
        raise HTTPException(status_code=401, detail="Expired or invalid token.")


def verify_token_ws(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[TOKEN_ALGORITHM])

        username = payload.get("username")
        secret = payload.get("secret")
        version = payload.get("version")

        if secret != GAME_KEY:
            return None
        
        if version != GAME_VERSION:
            return None

        if username is None: #talvez consultar nos ja conhecidos
            return None

        return username

    except JWTError:
        return None

