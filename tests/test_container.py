# Copyright 2022 The MathWorks, Inc.

"""
Test suite to validate the matlab-dockerfile.

This test suite will launch the container and test some features, e.g. users
permissions, the apt cache, the matlab executable...
These tests do not require a license file to run.
"""

import unittest
import os
import stat
import docker
import testinfra

IMAGE_NAME = os.environ.get("IMAGE_NAME")

################################################################################
################################################################################


class TestContainer(unittest.TestCase):
    """Test class to test the non-MATLAB related features of the Docker image"""

    @classmethod
    def setUpClass(cls):
        """Run the container"""
        cls.client = docker.from_env()
        cls.container = cls.client.containers.run(
            image=IMAGE_NAME, detach=True, stdin_open=True, entrypoint="/bin/bash"
        )
        cls.host = testinfra.get_host("docker://" + cls.container.id)

    @classmethod
    def tearDownClass(cls):
        """Stop and remove the container"""
        cls.container.stop()
        cls.container.remove()
        cls.client.close()

    ############################################################################

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
        """Test that packages specified in the Dockerfile are correctly installed."""
        packages = ["ca-certificates", "wget", "unzip"]
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

    def test_mpm_dir_absent(self):
        """Test that there is no mpm executable in the following directories"""
        directories = ("/", "/tmp", "/usr/share", "/usr/local", "/usr/bin")
        for dirname in directories:
            with self.subTest(dirname=dirname):
                self.assertNotIn("mpm", self.host.file(dirname).listdir())

    def test_absent_license_file(self):
        """Search for all .LIC files and for all .DAT files containing "licen"
        in the path (e.g. license, licenses, licence, ...). Error messages are
        redirected to the STDOUT and those containing 'Permission denied' are
        ignored. Ignore license files from the ignorable_files list. The
        test passes if the count of matched lines (grep -c) is 0.
        """
        ignorable_files = ["AHFormatter.lic"]
        matlab_dir = "/opt/matlab"
        if len(ignorable_files) >= 0:
            grep_args = '"Permission denied|' + "|".join(ignorable_files) + '"'
        else:
            grep_args = '"Permission denied"'

        self.assertEqual(
            self.host.run(
                f"find {matlab_dir} -iname *.lic -o -ipath *licen*.dat 2>&1 | \
                grep --count --extended-regexp --invert-match {grep_args}"
            ).stdout.rstrip("\n"),
            "0",
        )


################################################################################
################################################################################

if __name__ == "__main__":
    unittest.main()
