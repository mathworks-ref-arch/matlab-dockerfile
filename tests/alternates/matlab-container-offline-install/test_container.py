# Copyright 2024 The MathWorks, Inc.

"""
Test class to validate the "matlab-container-offline-install" Dockerfile.

This test suite will launch the container and test some features, e.g. users
permissions, the apt cache, the matlab executable...
These tests do not require a license file to run.
"""

from utils import base, helpers
import docker
import unittest

################################################################################


class TestContainer(base.TestCase):
    """Extend the test methods of the base TestCase class."""

    expected_ddux_force_enable = "true"
    expected_ddux_tags = ["MATLAB:FROM_SOURCE:DOCKERFILE:V1"]

    @classmethod
    def setUpClass(cls):
        """Run the container"""
        cls.client = docker.from_env()
        image_name = helpers.get_image_name()
        cls.container = cls.client.containers.run(
            image=image_name,
            detach=True,
            stdin_open=True,
            entrypoint="/bin/bash",
        )
        cls.install_dirname = "work"
        cls.release_tag = helpers.get_release_tag(image_name)
        super().setUpClass()

    @classmethod
    def tearDownClass(cls):
        """Stop and remove the container"""
        cls.container.stop()
        cls.container.remove()
        cls.client.close()

    ############################################################################

    def test_cannot_run_matlab_without_license(self):
        """Test that matlab cannot be run without mounting a valid license file."""
        matlab_cmd = "matlab"
        self.assertFalse(self.host.run(matlab_cmd).succeeded)

    def test_mpm_not_present(self):
        """Test that MPM is not present"""
        find_mpm = "find / -type f -name mpm -print"
        mpm_path = self.host.run(find_mpm).stdout.strip()
        self.assertEqual(mpm_path, "", f"Found mpm at path {mpm_path}")

    def test_installation_files_not_present(self):
        """Test that the installation files are not present"""
        archive_dir = "/archives"
        inst_files_format = "enc"
        find_installation_files = (
            f"find / -path '{archive_dir}/*.{inst_files_format}' -type f  -print"
        )
        inst_files_paths = self.host.run(find_installation_files).stdout.strip()
        self.assertEqual(
            inst_files_paths,
            "",
            f"Found *.{inst_files_format} files in {archive_dir}:\n{inst_files_paths}",
        )


################################################################################

if __name__ == "__main__":
    unittest.main()
