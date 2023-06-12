# Copyright 2023 The MathWorks, Inc.

"""Negative tests for failing builds"""

import unittest
import docker
import utils.testutils as utils
from pathlib import Path


class TestBrokenBuild(unittest.TestCase):
    """TestBrokenBuild contains test cases for failing builds"""

    @classmethod
    def setUpClass(cls):
        """Set up the test class"""
        cls.client = docker.from_env()
        # set a matlab release different from the one set in VersionInfo.xml (latest)
        # matlab_release should be a valid tag for the matlab-deps image.
        # E.g., matlab-deps:latest is valid, matlab-deps:r1999b is not
        cls.old_matlab_release = "r2019b"
        cls.dockerfile_dirpath = str(Path(__file__).parents[1])

    @classmethod
    def tearDownClass(cls):
        """Close the docker client"""
        cls.client.close()

    def test_mismatching_releases_raises_error(self):
        """
        Test that the build will fail when the "MATLAB_RELEASE" argument
        is different from the one contained in VersionInfo.xml ("latest")
        """

        # The failure message that we expect to see
        expected_fail_regex = (
            f"Provided release (.*) does not match release found in VersionInfo.xml"
        )

        with self.assertRaisesRegex(
            docker.errors.BuildError,
            expected_fail_regex,
        ):
            # Build the Docker image using the default value for MATLAB_RELEASE,
            # which does not match with the one in mocks/matlab-install/VersionInfo.xml
            self.client.images.build(
                path=self.dockerfile_dirpath,
                forcerm=True,
                buildargs={"MATLAB_RELEASE": self.old_matlab_release},
            )

    def test_mismatching_releases_displays_err_msg(self):
        """
        Test that the error message is displayed when the "MATLAB_RELEASE" argument
        is different from the one contained in VersionInfo.xml ("latest")
        """

        # The failure message that we expect to see
        expected_fail_msg = (
            f"Provided release ({self.old_matlab_release}) does not match "
            "release found in VersionInfo.xml"
        )

        build_msg = utils.get_build_output(
            docker_api_client=self.client.api,
            dockerfile_dirpath=self.dockerfile_dirpath,
            release=self.old_matlab_release,
        )

        self.assertTrue(
            any([expected_fail_msg in line for line in build_msg]),
            f"The error message '{expected_fail_msg}' was not displayed",
        )

    def test_install_error_message(self):
        """
        Test that the failure message is displayed if a failure occurs during the
        installation of matlab
        """

        fail_msg = "Failure message"

        fail_file = Path(self.dockerfile_dirpath) / "matlab-install" / "FAIL"

        with open(str(fail_file), "w") as ff:
            ff.write(fail_msg + "\n")
        self.addCleanup(utils.remove_file, fail_file)

        build_msg = utils.get_build_output(
            docker_api_client=self.client.api,
            dockerfile_dirpath=self.dockerfile_dirpath,
            release="latest",
        )

        self.assertTrue(any([fail_msg in msg for msg in build_msg]))


if __name__ == "__main__":
    unittest.main()
