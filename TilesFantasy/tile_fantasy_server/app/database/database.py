import mariadb
import json
import random
import uuid
import base64

#----------------#Credentials#----------------#
DB_User = "gateway_server1"
DB_Password = "secret123"
DB_Host = "host.docker.internal"
DB_Port = 3306
DB_Database = "tile_fantasy_db"


#----------------#Base-Functions#----------------#

def generate_player_id() -> str:
    return base64.urlsafe_b64encode(
        uuid.uuid4().bytes
    ).rstrip(b"=").decode("ascii")

def connect_database():
    conn = mariadb.connect(user = DB_User,password = DB_Password,host= DB_Host,port = DB_Port,database = DB_Database)
    return conn

def disconnect_database(conn) -> None:
    conn.cursor().close()
    conn.close()


def run_instruction_database(instruction : str, params : tuple, conn):
    try:
        cursor = conn.cursor()
        cursor.execute(instruction, params)
        conn.commit()
        try:
            response = cursor.fetchall()
            return response
        except mariadb.Error as e:
            if str(e) != "Cursor doesn't have a result set":
                print(e)
            return None
    except mariadb.Error as e:
        print(e)
        return None


#----------------#Game-Functions#----------------#

def update_player_position_db(player_id : str, x : float, y : float, region : str) -> bool:
    conn = connect_database()

    instruction = "UPDATE player_data SET positionX = ?, positionY = ?, positionR = ?, last_update = CURRENT_TIMESTAMP WHERE player_id = ?;" 
    response = run_instruction_database(instruction, (x, y, region, player_id, ), conn)

    disconnect_database(conn)

    return True


def get_player_location_db(player_id : str) -> tuple[float, float, str]:
    conn = connect_database()

    instruction = "SELECT positionX, positionY, positionR FROM player_data WHERE player_id = ?;"
    response = run_instruction_database(instruction, (player_id,), conn)

    disconnect_database(conn)

    if len(response) < 1:
        return(None, None, "")

    return response[0]


#----------------#Api-Functions#----------------#
def register_player_db(username : str, password : str, char_name : str, nation : str) -> str:
    conn = connect_database()

    player_id : str = generate_player_id()
    y : float = 1.0
    x : float = 1.0
    r : str = "steel_city"

    instruction = "INSERT INTO player_data (player_id, username, password, name, nation, positionX, positionY, positionR) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
    response = run_instruction_database(instruction, (player_id, username, password, char_name, nation, x, y, r,), conn)

    disconnect_database(conn)
    #deletar
    response = generate_player_id()

    return response

# print("registering", register_player_db("teste2", "123", "CarlaBlack", "steel_nation"))


def check_credentials_db(username : str, password : str) -> bool:
    conn = connect_database()

    instruction = "SELECT player_id FROM player_data WHERE username = ? AND password = ?;"
    response = run_instruction_database(instruction, (username, password,), conn)

    disconnect_database(conn)

    return len(response) > 0



def get_player_id_db(username : str) -> str:
    conn = connect_database()

    instruction = "SELECT player_id FROM player_data WHERE username = ?;"
    response = run_instruction_database(instruction, (username,), conn)

    disconnect_database(conn)

    if len(response) < 1:
        return None

    return response[0][0]

