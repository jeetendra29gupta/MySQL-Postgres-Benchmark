# main_app.py
import logging
import threading
import time

import psutil

from mysql_service import run_sql_file_mysql
from postgresql_service import run_sql_file_postgresql
from utils import timeit

# Set up logger
logger = logging.getLogger(__name__)


@timeit
def check_mysql_execution_time():
    """Run MySQL SQL script and monitor MySQL process performance."""
    stop_event = threading.Event()

    # Start MySQL monitoring in a separate thread
    monitoring_thread = threading.Thread(target=monitor_mysql, args=(stop_event,))
    monitoring_thread.daemon = True
    monitoring_thread.start()

    logger.info("Running MySQL SQL script.")
    run_sql_file_mysql("mysql.sql")

    stop_event.set()
    monitoring_thread.join()

    logger.info("MySQL SQL script execution completed.")


@timeit
def check_postgresql_execution_time():
    """Run PostgreSQL SQL script and monitor PostgreSQL process performance."""
    stop_event = threading.Event()

    # Start PostgreSQL monitoring in a separate thread
    monitoring_thread = threading.Thread(target=monitor_postgresql, args=(stop_event,))
    monitoring_thread.daemon = True
    monitoring_thread.start()

    logger.info("Running PostgreSQL SQL script.")
    run_sql_file_postgresql("postgresql.sql")

    stop_event.set()
    monitoring_thread.join()

    logger.info("PostgreSQL SQL script execution completed.")


def monitor_mysql(stop_event):
    """Monitor MySQL process using psutil."""
    mysql_pid = None
    for _ in range(5):
        for proc in psutil.process_iter(['pid', 'name']):
            if 'mysqld' in proc.info['name']:
                mysql_pid = proc.info['pid']
                logger.info("MySQL process found!")
                break
        if mysql_pid:
            break
        else:
            time.sleep(2)

    if not mysql_pid:
        logger.warning("MySQL process not found.")
        return

    while not stop_event.is_set():
        try:
            proc = psutil.Process(mysql_pid)
            cpu_usage = proc.cpu_percent(interval=1)
            memory_info = proc.memory_info()
            memory_usage = memory_info.rss / (1024 * 1024)
            logger.info(f"MySQL CPU usage: {cpu_usage}%")
            logger.info(f"MySQL Memory usage: {memory_usage:.2f} MB")
            time.sleep(1)
        except psutil.NoSuchProcess:
            logger.error("MySQL process terminated.")
            break


def monitor_postgresql(stop_event):
    """Monitor PostgreSQL process using psutil."""
    postgres_pid = None
    for _ in range(5):
        for proc in psutil.process_iter(['pid', 'name']):
            if 'postgres' in proc.info['name']:
                postgres_pid = proc.info['pid']
                logger.info("PostgreSQL process found!")
                break
        if postgres_pid:
            break
        else:
            time.sleep(2)

    if not postgres_pid:
        logger.warning("PostgreSQL process not found.")
        return

    while not stop_event.is_set():
        try:
            proc = psutil.Process(postgres_pid)
            cpu_usage = proc.cpu_percent(interval=1)
            memory_info = proc.memory_info()
            memory_usage = memory_info.rss / (1024 * 1024)
            logger.info(f"PostgreSQL CPU usage: {cpu_usage}%")
            logger.info(f"PostgreSQL Memory usage: {memory_usage:.2f} MB")
            time.sleep(1)
        except psutil.NoSuchProcess:
            logger.error("PostgreSQL process terminated.")
            break


if __name__ == '__main__':
    check_mysql_execution_time()
    check_postgresql_execution_time()
