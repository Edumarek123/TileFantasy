from fastapi import APIRouter, HTTPException
from app.schemas.schemas import Token
from app.auth.auth import create_access_token, verify_token
from app.config.config import GAME_VERSION


router = APIRouter()

#----------------#Login#----------------#
@router.post("/login")
def login(token: Token):
    username = token.payload["username"]
    password = token.payload["password"]
    version = token.payload["version"]

    if version != GAME_VERSION:
        raise HTTPException(status_code=426, detail="Please Update the game.")

    #melhorar sistema login
    if username != "admin" or password != "123":
        raise HTTPException(status_code=401, detail="Credentials Invalid")

    token = create_access_token(username)

    return {"token": token}


#----------------#Actions#----------------#
@router.post("/data")
def receive_data(token : Token):  
    username : str = verify_token(token.token)

    print(token.payload)

    return {"success": True, "user": username, "data": token}


