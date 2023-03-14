# Copyright 2023 The MathWorks, Inc.


import re
import time


def wait_for_file(host, filepath, timeout=30):
    """Wait for a file to be created in a 'testinfra.Host' object.

    HOST is a testinfra.Host object
    FILEPATH is the full path of the file to be waited for

    If the file is not found after TIMEOUT seconds, an error is raised.
    """
    start = time.time()
    while (time.time() - start < timeout) and not host.file(filepath).exists:
        time.sleep(0.2)
    if not host.file(filepath).exists:
        raise TimeoutError(
            f"Hit waiting time of timeout={timeout}s for file {filepath}."
        )


def get_release_from_string(string):
    match = re.search("r20[2-9][0-9][ab]", string, re.IGNORECASE)
    if match:
        return match.group(0)
    else:
        return ""


def wait_for_cmd(container, cmd, timeout=10):
    """
    Wait until a process is started in the container CONTAINER. The process that
    is waited for has a "CMD" that regex-matches the input CMD.
    CONTAINER is a Container class from the docker package."""

    def update_cmd_list():
        ps_res = container.top(ps_args="-o pid,cmd")
        idx = ps_res["Titles"].index("CMD")
        return [proc[idx] for proc in ps_res["Processes"]]

    start = time.time()
    while "\n".join(update_cmd_list()).count(cmd) == 0 and (
        time.time() - start < timeout
    ):
        time.sleep(0.2)
    if "\n".join(update_cmd_list()).count(cmd) == 0:
        raise ValueError(f"The process {cmd} is not running.")
