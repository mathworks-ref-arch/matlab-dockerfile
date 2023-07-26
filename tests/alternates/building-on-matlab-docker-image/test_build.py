# Copyright 2023 The MathWorks, Inc.

"""
Test class to validate the build arguments of the "building-on-matlab-docker-image" Dockerfile.
"""

from utils import helpers
import docker
from pathlib import Path
import unittest

################################################################################


class TestBuild(unittest.TestCase):
    """Extend the test methods of the base TestCase class."""

    @classmethod
    def setUpClass(cls):
        """Set up the test class."""
        cls.client = docker.from_env()
        cls.dockerfile_dirpath = str(
            Path(__file__).parents[3] / helpers.get_alternates_path()
        )

    @classmethod
    def tearDownClass(cls):
        """Close the docker client"""
        cls.client.close()

    ############################################################################

    def test_mpm_error_is_shown(self):
        """Test that the mpm error is correctly reported."""
        invalid_product = "Invalid_Product"
        additional_products = [
            "Statistics_and_Machine_Learning_Toolbox",
            invalid_product,
        ]
        expected_release = "r2022b"

        expected_err_msg = "Unable to find installation candidates for these products:"

        with self.assertRaises(docker.errors.BuildError) as be:
            image, _ = self.client.images.build(
                path=self.dockerfile_dirpath,
                forcerm=True,
                nocache=True,
                buildargs={
                    "MATLAB_RELEASE": expected_release,
                    "ADDITIONAL_PRODUCTS": " ".join(additional_products),
                },
            )
            image.remove()

        build_log = list(be.exception.build_log)

        expected_products_line = "--products=" + " ".join(additional_products)
        self.assertTrue(
            any([expected_products_line in l.get("stream", "") for l in build_log]),
            f"expected line {expected_products_line} not found in build log\n{build_log}",
        )

        expected_release_line = "--release=" + expected_release.capitalize()
        self.assertTrue(
            any([expected_release_line in l.get("stream", "") for l in build_log]),
            f"expected line {expected_release_line} not found in build log\n{build_log}",
        )

        self.assertTrue(
            any([expected_err_msg in l.get("stream", "") for l in build_log]),
            f"expected line '{expected_err_msg}' not found in build log\n{build_log}",
        )
        self.assertTrue(
            any([invalid_product in l.get("stream", "") for l in build_log]),
            f"expected line '{invalid_product}' not found in build log\n{build_log}",
        )


################################################################################

if __name__ == "__main__":
    unittest.main()
