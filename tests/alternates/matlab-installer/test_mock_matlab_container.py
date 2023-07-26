# Copyright 2023 The MathWorks, Inc.

"""
Test suite to validate the matlab-dockerfile with the matlab installer.

This test suite will launch the container and test some features, e.g. users
permissions, the apt cache, the matlab executable...
These tests do not require a license file to run.
"""

from utils import base, helpers
from pathlib import Path
import docker
import unittest

CUSTOM_CMD = "-some -flags"

################################################################################


class TestMockMatlabContainer(base.TestCase):
    """Test class to test the non-MATLAB related features of the Docker image"""

    @classmethod
    def setUpClass(cls):
        """Run the container"""
        cls.client = docker.from_env()
        image_name = helpers.get_image_name()
        cls.container = cls.client.containers.run(
            image=image_name, detach=True, stdin_open=True, command=CUSTOM_CMD
        )
        cls.expected_ddux_force_enable = "true"
        cls.expected_ddux_tags = ["MATLAB:MATLAB_INSTALLER:DOCKERFILE:V1"]
        cls.install_dirname = "matlab-install"
        cls.release_tag = helpers.get_release_tag(image_name)
        super().setUpClass()

    @classmethod
    def tearDownClass(cls):
        """Stop and remove the container"""
        cls.container.stop()
        cls.container.remove()
        cls.client.close()

    ############################################################################

    def test_entrypoint_called_mocked_matlab(self):
        """
        Test that the entrypoint script calls the (mocked) matlab executable
        with the expected flags.
        """
        self.assertEqual(
            self.host.file("matlab.log").content_string.rstrip(), f"MATLAB {CUSTOM_CMD}"
        )

    def test_network_lic_file_present(self):
        """Test that the network.lic file is in the right location."""
        str_matlab_bin_path = self.host.check_output("readlink -f $(which matlab)")
        network_lic_path = (
            Path(str_matlab_bin_path).parents[1] / "licenses" / "network.lic"
        )
        self.assertTrue(self.host.file(str(network_lic_path)).exists)


################################################################################


if __name__ == "__main__":
    unittest.main()
