# Copyright 2023 The MathWorks, Inc.

"""
Test class to validate the "building-on-matlab-docker-image" Dockerfile.

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

    @classmethod
    def setUpClass(cls):
        """Run the container"""
        cls.client = docker.from_env()
        image_name = helpers.get_image_name()
        cls.container = cls.client.containers.run(
            image=image_name, detach=True, stdin_open=True, entrypoint="/bin/bash"
        )
        cls.expected_ddux_force_enable = "true"
        cls.expected_ddux_tags = [
            "MATLAB:DOCKERHUB:V1",
            "MATLAB:TOOLBOXES:DOCKERFILE:V1",
        ]
        cls.install_dirname = "mpm"
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

    def test_packages_present(self):
        """Test that packages specified in the Dockerfile are correctly installed."""
        packages = ["ca-certificates", "sudo"]
        for pkg in packages:
            with self.subTest(package=pkg):
                self.assertTrue(
                    self.host.package(pkg).is_installed,
                    f"package {pkg} is not installed",
                )


################################################################################

if __name__ == "__main__":
    unittest.main()
