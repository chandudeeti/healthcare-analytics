import os
from dotenv import load_dotenv
import snowflake.connector

load_dotenv()

conn = snowflake.connector.connect(
    account=os.environ['SNOWFLAKE_ACCOUNT'],
    user=os.environ['SNOWFLAKE_USER'],
    password=os.environ['SNOWFLAKE_PASSWORD'],
    role='ACCOUNTADMIN',
    warehouse='healthcare_wh',
    database='healthcare_analytics',
    schema='raw'
)

cursor = conn.cursor()

put_command = "PUT 'file://C:/Users/chandu.deeti/Downloads/10k_synthea_covid19_csv/10k_synthea_covid19_csv/observations.csv' @synthea_stage AUTO_COMPRESS=TRUE"

print(put_command)
cursor.execute(put_command)

for row in cursor.fetchall():
    print(row)

cursor.close()
conn.close()