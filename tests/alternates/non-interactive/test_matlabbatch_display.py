# Copyright 2024 The MathWorks, Inc.

"""
Test class to validate the non-interactive dockerfile.

This test class will launch matlab-batch with a virtual display.
"""

import unittest
from utils import helpers
import docker
import os
from pathlib import Path


################################################################################
class TestMATLABBatchDisplay(unittest.TestCase):
    """Test that matlab-batch can run workflows requiring a virtual display"""

    @classmethod
    def setUpClass(cls):
        """Get the docker client and image to test"""
        cls.client = docker.from_env()
        cls.image_name = helpers.get_image_name()

    @classmethod
    def tearDownClass(cls):
        """Close the client"""
        cls.client.close()

    ############################################################################

    @unittest.skipIf(
        helpers.get_release().lower() < "r2023b",
        "Release is too old. Only releases after r2023b are supported",
    )
    def test_display_workflow(self):
        """
        Test that 'matlab -batch runDisplayTest' executes correctly.
        runDisplayTest will run some example tests that require a display.
        This is equivalent to running

        docker run --init -it --rm -e MLM_LICENSE_TOKEN=... non-interactive:r2024a matlab-batch runDisplayTest
        """
        cmd = "matlab-batch runDisplayTest"
        mtest_file_name = "runDisplayTest.m"
        timeout = 180

        trg_mtest_file = f"/home/matlab/{mtest_file_name}"
        src_mtest_file = str(Path(__file__).parent.resolve() / mtest_file_name)
        test_mount = docker.types.Mount(
            target=trg_mtest_file,
            source=src_mtest_file,
            type="bind",
        )

        self.container = self.client.containers.run(
            image=self.image_name,
            init=True,
            detach=True,
            stdin_open=True,
            environment={"MLM_LICENSE_TOKEN": os.getenv("BATCH_TOKEN")},
            mounts=[test_mount],
            command=cmd,
        )

        self.addCleanup(lambda: self.container.remove(force=True))

        result = self.container.wait(timeout=timeout)
        status_code = result.get("StatusCode")
        error = result.get("Error")
        logs = self.container.logs().strip().decode("utf-8")
        self.assertEqual(status_code, 0, logs)
        self.assertIsNone(error, logs)


################################################################################

if __name__ == "__main__":
    unittest.main()
