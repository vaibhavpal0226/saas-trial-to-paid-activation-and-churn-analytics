import pandas as pd
import os
import time
import logging
from sqlalchemy import create_engine

# Logging & Configuration
log_directory = r'D:\Visualization_and_Programming\Projects\SaaS_Free_Trial_Paid_Conversion_Drop\logs'
log_file = os.path.join(log_directory, 'ingestion_db.log')

if not os.path.exists(log_directory):
    os.makedirs(log_directory)

logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    filemode="a"
)

# Database Connection
DB_USER = 'root'
DB_PW = 'your_password'
DB_HOST = 'localhost'
DB_PORT = '3306'
DB_NAME = 'saas_conversion'

engine = create_engine(f"mysql+pymysql://{DB_USER}:{DB_PW}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

def ingest_db(df, table_name, engine):
    df.to_sql(table_name, con=engine, if_exists='replace', index=False)

def load_raw_data(folder_path):
    start_time = time.time()
    logging.info(f"Starting ingestion fron {folder_path}")

    try:
        files = os.listdir(folder_path)
    except FileNotFoundError:
        print(f"The folder path {folder_path} does not exist!")
        logging.error(f"Path not found: {folder_path}")
        return

    for file in files:
        if file.endswith('.csv'):
            file_start = time.time()
            try:
                full_path = os.path.join(folder_path, file)
                df = pd.read_csv(full_path)
                df.columns = [c.replace(' ', '_').lower() for c in df.columns]
                table_name = file[:-4]

                logging.info(f"Ingesting {file} into MySQL table {table_name}")
                ingest_db(df, table_name, engine)

                file_end = time.time()
                duration = round(file_end - file_start, 2)
                print(f"Ingested {file} ({len(df)} rows) in {duration}s")
            
            except Exception as e:
                logging.error(f"Failed to process {file}: {e}")
                print(f"Failed to process {file}. Check logs.")
    
    total_duration = round(time.time() - start_time, 2)
    logging.info(f"Ingestion Completed. Total time taken: {total_duration}s")
    print(f"\nProcess finished in {total_duration}s")


if __name__ == '__main__':
    
    target_folder = r'D:\Visualization_and_Programming\Projects\SaaS_Free_Trial_Paid_Conversion_Drop\data'
    load_raw_data(target_folder)