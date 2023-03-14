# Copyright 2022-2023 The MathWorks, Inc.

"""
Test suite to validate the matlab-dockerfile.

This test suite will launch MATLAB in the container and test some MATLAB-related
features.
These tests do require a license file to run.
"""

import unittest
import os
import utils
import docker
import testinfra

IMAGE_NAME = os.environ.get("IMAGE_NAME")
LICENSE_FILE_PATH = os.environ.get("LICENSE_FILE_PATH")


@unittest.skipIf(
    not os.path.exists(LICENSE_FILE_PATH) or os.stat(LICENSE_FILE_PATH).st_size <= 1,
    "matlab license unavailable",
)
class TestMatlab(unittest.TestCase):
    """Test that MATLAB get launched correctly"""

    diaryname = "log.txt"
    diaryfullpath = "/home/matlab/" + diaryname
    cont_lic_file_path = "/tmp/license.lic"
    undesired_status = ["removing", "exited", "dead"]

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
        self.assertNotIn(
            self.container.status,
            self.undesired_status,
            f"Container {self.container.name} is in '{self.container.status}' status",
        )
        utils.wait_for_cmd(self.container, "MATLAB")
        self.assertGreater(
            len(self.host.process.filter(user="matlab", comm="MATLAB")), 0
        )
        self.assertNotIn(
            self.container.status,
            self.undesired_status,
            f"Container {self.container.name} is in '{self.container.status}' status",
        )

    def test_matlab_version(self):
        """Test that the release number written to the VER_OUTPUT_FILE file and
        the one from /opt/ver coincide"""
        self.assertNotIn(
            self.container.status,
            self.undesired_status,
            f"Container {self.container.name} is in '{self.container.status}' status",
        )
        utils.wait_for_file(self.host, self.diaryfullpath, timeout=10)
        ver_from_mat = self.host.file(self.diaryfullpath).content_string.rstrip("\n")
        self.assertEqual(
            utils.get_release_from_string(IMAGE_NAME).upper().lstrip("R"),
            ver_from_mat.upper().lstrip("R"),
        )
        self.assertNotIn(
            self.container.status,
            self.undesired_status,
            f"Container {self.container.name} is in '{self.container.status}' status",
        )


##################################################################################

if __name__ == "__main__":
    unittest.main()
