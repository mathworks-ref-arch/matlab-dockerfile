# Copyright 2022-2023 The MathWorks, Inc.

"""
Test class to validate the matlab-dockerfile.

This test class will launch MATLAB in the container and test some MATLAB-related
features.
These tests do require a license file to run.
"""

import unittest
from utils import helpers
import docker
import testinfra


################################################################################
class TestMatlab(unittest.TestCase):
    """Test that MATLAB gets launched correctly"""

    undesired_status = ["removing", "exited", "dead"]

    @classmethod
    def setUpClass(cls):
        cls.client = docker.from_env()
        cls.diaryfullpath = "/home/matlab/log.txt"
        cls.image_name = helpers.get_image_name()

        source_lic_filepath = helpers.get_license_filepath()
        lic_filepath = "/tmp/license.lic"
        mount = [
            docker.types.Mount(
                target=lic_filepath,
                source=source_lic_filepath,
                type="bind",
            ),
        ]
        cmd = f"-r \"fid=fopen('{cls.diaryfullpath}','w'); \
            fprintf(fid,version('-release')); \
            fclose(fid);\""
        env = {"MLM_LICENSE_FILE": lic_filepath}

        cls.container = cls.client.containers.run(
            image=cls.image_name,
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

    def setUp(self):
        """Fail if the container is not running."""
        self.assertNotIn(
            self.container.status,
            self.undesired_status,
            f"Container {self.container.name} is in '{self.container.status}' status",
        )

    def tearDown(self):
        """Fail if the container is not running."""
        self.assertNotIn(
            self.container.status,
            self.undesired_status,
            f"Container {self.container.name} is in '{self.container.status}' status",
        )

    ############################################################################

    def test_matlab_runs(self):
        """Test that matlab is running."""
        helpers.wait_for_cmd(self.container, "MATLAB")
        self.assertGreater(
            len(self.host.process.filter(user="matlab", comm="MATLAB")), 0
        )

    def test_matlab_version(self):
        """Test that the release number written to VER_OUTPUT_FILE and
        the one from the image name coincide."""
        helpers.wait_for_file(self.host, self.diaryfullpath, timeout=10)
        ver_from_mat = self.host.file(self.diaryfullpath).content_string.rstrip("\n")
        self.assertEqual(
            helpers.get_release_from_string(self.image_name).upper().lstrip("R"),
            ver_from_mat.upper().lstrip("R"),
        )


################################################################################

if __name__ == "__main__":
    unittest.main()
