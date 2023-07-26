# Copyright 2023 The MathWorks, Inc.

"""
Set of helpers functions for Docker tests.
"""

import re
import os
import time


def _getenv_(key):
    try:
        return os.environ.get(key)
    except:
        raise ValueError(f"environment variable {key} not defined")


def get_image_name():
    return _getenv_("IMAGE_NAME")


def get_license_filepath():
    filepath = _getenv_("LICENSE_FILE_PATH")
    if filepath == "":
        raise ValueError("environment variable 'LICENSE_FILE_PATH' is empty")
    if not os.path.exists(filepath):
        raise ValueError(f"license file {filepath} does not exist")
    if os.stat(filepath).st_size <= 1:
        raise ValueError(f"license file {filepath} is empty")
    return filepath


def get_alternates_path():
    return _getenv_("ALT_PATH")


def get_release_from_string(string):
    """Get the release from a string"""
    match = re.search("r20[2-9][0-9][ab]", string, re.IGNORECASE)
    if match:
        return match.group(0)
    else:
        return ""


def get_release_tag(string):
    """Get the docker tag from a string containing a release"""
    tag = get_release_from_string(string)
    if tag == "":
        tag = "latest"
    return tag


def remove_file(filepath):
    """Remove the file with path FILEPATH"""
    try:
        os.remove(filepath)
    except OSError:
        pass


## Wait functions ##


def wait_for_file(host, filepath, timeout=30):
    """Wait for a file to be created in a 'testinfra.Host' object.

    HOST is a testinfra.Host object
    FILEPATH is the full path of the file to be waited for

    If the file is not found after TIMEOUT seconds, an error is raised.
    """

    def file_exists():
        return host.file(filepath).exists

    try:
        wait_for(file_exists, timeout)
    except TimeoutError:
        raise ValueError(f"The file {filepath} does not exists.")


def wait_for_msg_in_log(container, msg, timeout=30):
    """Wait until the expected log message is printed to stdout"""

    def msg_is_logged():
        return msg in container.logs().decode()

    try:
        wait_for(msg_is_logged, timeout)
    except TimeoutError:
        raise RuntimeError(f"The message {msg} was not printed to stdout.")


def wait_for_container_status(client, id, status, timeout=30):
    """Wait until the container is in a desired state"""

    def container_in_desired_state():
        return client.containers.get(id).status == status

    try:
        wait_for(container_in_desired_state, timeout)
    except TimeoutError:
        raise RuntimeError(f"The container {id} is {client.containers.get(id).status}.")


def wait_for_cmd(container, cmd, timeout=30):
    """
    Wait until a process is started in the container CONTAINER. The process that
    is waited for has a "CMD" that regex-matches the input CMD.
    CONTAINER is a Container class from the docker package."""

    def update_cmd_list():
        ps_res = container.top(ps_args="-o pid,cmd")
        idx = ps_res["Titles"].index("CMD")
        return [proc[idx] for proc in ps_res["Processes"]]

    def cmd_has_started():
        return "\n".join(update_cmd_list()).count(cmd) != 0

    try:
        wait_for(cmd_has_started, timeout)
    except:
        raise ValueError(f"The process {cmd} is not running.")


def wait_for(bool_fnc, timeout=60, interval=0.3):
    start = time.time()
    while time.time() - start <= timeout and not bool_fnc():
        time.sleep(interval)
    if time.time() - start > timeout:
        raise TimeoutError(
            f"The condition {bool_fnc.__name__} is still false after {timeout} seconds"
        )
