import os
from penvy.string.string_in_file import file_contains_string


class DatabricksConnectDetector:
    def detect(self):
        poetry_lock_path = os.getcwd() + os.sep + "poetry.lock"

        return file_contains_string('name = "databricks-connect"', poetry_lock_path)
