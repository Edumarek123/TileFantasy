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


def get_charactere_sheet_db(player_id: str) -> dict:

    conn = connect_database()

    instruction = "SELECT player_id, name, nation, level, title, character_creation_date, death_date, soul_crystals_collected, soul_crystals, hours_played, items_crafted, quests_created, quests_completed, creatures_killed, bosses_defeated, players_killed, duels_won, inventory, grimoire, profession, inbox, positionX, positionY, positionR, strength, dexterity, intellect, vitality, soul FROM player_data WHERE player_id = ?;"

    response = run_instruction_database(instruction, (player_id,), conn)

    disconnect_database(conn)

    if not response:
        return {}

    row = response[0]

    sheet = {
        "player_id": row[0],
        "name": row[1],
        "nation": row[2],
        "level": row[3],
        "title": row[4],
        "character_creation_date": str(row[5]) if row[5] else "",
        "death_date": str(row[6]) if row[6] else "",
        "soul_crystals_collected": row[7],
        "soul_crystals": row[8],
        "hours_played": row[9],
        "items_crafted": row[10],
        "quests_created": row[11],
        "quests_completed": row[12],
        "creatures_killed": row[13],
        "bosses_defeated": row[14],
        "players_killed": row[15],
        "duels_won": row[16],
        "inventory": json.loads(row[17]) if row[17] else {},
        "grimoire": json.loads(row[18]) if row[18] else {},
        "profession": json.loads(row[19]) if row[19] else {},
        "inbox": json.loads(row[20]) if row[20] else {},
        "positionX": row[21],
        "positionY": row[22],
        "positionR": row[23],
        "base_stats": {
            "strength": row[24],
            "dexterity": row[25],
            "intellect": row[26],
            "vitality": row[27],
            "soul": row[28]
        }
    }

    return sheet