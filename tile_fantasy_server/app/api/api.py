from fastapi import APIRouter, HTTPException
from app.schemas.schemas import Token
from app.auth.auth import create_access_token, verify_token
from app.config.config import GAME_VERSION
from app.database.database import  check_credentials_db, get_player_id_db

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
    if not check_credentials_db(username, password):
        raise HTTPException(status_code=401, detail="Credentials Invalid")

    player_id = get_player_id_db(username)
    if player_id == None:
        raise HTTPException(status_code=401, detail="Internal Error")


    token = create_access_token(player_id)

    return {"token": token}


#----------------#Actions#----------------#
@router.post("/data")
def receive_data(token : Token):  
    username : str = verify_token(token.token)

    print(token.payload)

    return {"success": True, "user": username, "data": token}


