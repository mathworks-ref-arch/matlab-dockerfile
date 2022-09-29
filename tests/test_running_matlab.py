# Copyright 2022 The MathWorks, Inc.

"""
Test suite to validate the matlab-dockerfile.

This test suite will launch MATLAB in the container and test some MATLAB-related
features.
These tests do require a license file to run.
"""

import unittest
import os
import re
import time
import docker
import testinfra

IMAGE_NAME = os.environ.get("IMAGE_NAME")
LICENSE_FILE_PATH = os.environ.get("LICENSE_FILE_PATH")


def wait_for_file(host, filepath, timeout=120):
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
            f"Hit waiting time of timeout={timeout} for file {filepath}."
        )


def get_release():
    match = re.search("r20[2-9][0-9][ab]", IMAGE_NAME, re.IGNORECASE)
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


class TestMatlab(unittest.TestCase):
    """Test that MATLAB get launched correctly"""

    diaryname = "log.txt"
    diaryfullpath = "/home/matlab/" + diaryname
    cont_lic_file_path = "/tmp/license.lic"

    @classmethod
    def setUpClass(cls):
        cls.client = docker.from_env()
        mount = [
            docker.types.Mount(
                target=cls.cont_lic_file_path,
                source=LICENSE_FILE_PATH,
                type="bind",
            ),
        ]
        cmd = f"-r \"fid=fopen('{cls.diaryname}','w'); \
            fprintf(fid,version('-release')); \
            fclose(fid);\""
        env = {"MLM_LICENSE_FILE": cls.cont_lic_file_path}

        cls.container = cls.client.containers.run(
            image=IMAGE_NAME,
            detach=True,
            stdin_open=True,
            environment=env,
            mounts=mount,
            command=cmd,
        )
        cls.host = testinfra.get_host("docker://" + cls.container.id)

    @classmethod
    def tearDownClass(cls):
        """Stop and remove the container."""
        cls.container.stop()
        cls.container.remove()
        cls.client.close()

    def test_matlab_runs(self):
        """Test that matlab is running"""
        wait_for_cmd(self.container, "MATLAB")
        self.assertGreater(
            len(self.host.process.filter(user="matlab", comm="MATLAB")), 0
        )

    def test_matlab_version(self):
        """Test that the release number written to the VER_OUTPUT_FILE file and
        the one from /opt/ver coincide"""
        wait_for_file(self.host, self.diaryfullpath)
        ver_from_mat = self.host.file(self.diaryfullpath).content_string.rstrip("\n")
        self.assertEqual(
            get_release().upper().lstrip("R"), ver_from_mat.upper().lstrip("R")
        )


##################################################################################

if __name__ == "__main__" and os.path.exists(LICENSE_FILE_PATH):
    unittest.main()
