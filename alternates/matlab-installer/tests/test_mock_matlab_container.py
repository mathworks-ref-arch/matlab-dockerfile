# Copyright 2023 The MathWorks, Inc.

"""
Test suite to validate the matlab-dockerfile.

This test suite will launch the container and test some features, e.g. users
permissions, the apt cache, the matlab executable...
These tests do not require a license file to run.
"""

import unittest
from pathlib import Path
import stat
import docker
import testinfra
import os

IMAGE_NAME = os.environ.get("IMAGE_NAME")
CUSTOM_CMD = "-some -flags"

################################################################################
################################################################################


class TestMockMatlabContainer(unittest.TestCase):
    """Test class to test the non-MATLAB related features of the Docker image"""

    @classmethod
    def setUpClass(cls):
        """Run the container"""
        cls.client = docker.from_env()
        cls.container = cls.client.containers.run(
            image=IMAGE_NAME, detach=True, stdin_open=True, command=CUSTOM_CMD
        )
        cls.host = testinfra.get_host("docker://" + cls.container.id)

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
        with the expected flags"""
        self.assertEqual(
            self.host.file("matlab.log").content_string.rstrip(), f"MATLAB {CUSTOM_CMD}"
        )

    def test_current_user(self):
        """Test that the standard user is 'MATLAB' and its shell is bash."""
        self.assertEqual(self.host.user().name, "matlab")
        self.assertEqual(self.host.user().shell, "/bin/bash")

    def test_ddux(self):
        """Test that the DDUX environment variables are set."""
        mw_ddux_force_enable = self.host.check_output("echo $MW_DDUX_FORCE_ENABLE")
        mw_context_tags = self.host.check_output("echo $MW_CONTEXT_TAGS")
        self.assertEqual(mw_ddux_force_enable, "true")
        self.assertEqual(
            mw_context_tags,
            "MATLAB:MATLAB_INSTALLER:DOCKERFILE:V1",
        )

    def test_users(self):
        """Test that the expected users exist."""
        users = ("root", "matlab")
        for user in users:
            with self.subTest(username=user):
                self.assertTrue(self.host.user(user).exists)

    def test_sudo(self):
        """Test that matlab user has sudo permission"""
        self.assertEqual(self.host.user().name, "matlab")
        self.assertTrue(self.host.run("sudo echo 'Hello World'").succeeded)

    def test_apt_cache_is_clean(self):
        """Test that the apt cache got cleaned after package installations"""
        self.assertSetEqual(
            set(self.host.file("/var/cache/apt/archives").listdir()),
            {"lock", "partial"},
        )

    def test_packages_present(self):
        """
        Test that packages installed in the base docker image (matlab-deps)
        are also installed here.
        """
        packages = ["ca-certificates", "sudo", "wget", "unzip"]
        for pkg in packages:
            with self.subTest(package=pkg):
                self.assertTrue(self.host.package(pkg).is_installed)

    def test_matlab_is_on_path(self):
        """Test that matlab is on the PATH"""
        self.assertTrue(self.host.run("which matlab").succeeded)

    def test_matlab_executable(self):
        """Test that the matlab file is executable"""
        matlab_executable_path = self.host.check_output(
            "which matlab | xargs readlink -f"
        ).rstrip("\n")
        self.assertRegex(
            stat.filemode(stat.S_IMODE(self.host.file(matlab_executable_path).mode)),
            "r.xr-xr-x",
        )

    def test_matlab_install_dir_absent(self):
        """Test that there is no matlab-install sub-directory in the following
        directories"""
        directories = ("/", "/tmp")
        for dirname in directories:
            with self.subTest(dirname=dirname):
                self.assertNotIn("matlab-install", self.host.file(dirname).listdir())

    def test_network_lic_file_present(self):
        """Test that the network.lic file is in the right location."""

        str_matlab_bin_path = self.host.check_output("readlink -f $(which matlab)")
        matlab_dir = Path(str_matlab_bin_path).parents[1]
        network_lic_path = matlab_dir / "licenses" / "network.lic"
        self.assertTrue(self.host.file(str(network_lic_path)).exists)


################################################################################
################################################################################

if __name__ == "__main__":
    unittest.main()
