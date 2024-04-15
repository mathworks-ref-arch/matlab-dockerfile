# Copyright 2024 The MathWorks, Inc.

"""
Test class to validate the "non-interactive" Dockerfile.
This test suite require a valid batch licensing token.
"""

from utils import base, helpers
import docker
import os
import unittest

################################################################################


class TestMatlabBatch(base.TestCase):
    """Extend the test methods of the base TestCase class."""

    @classmethod
    def setUpClass(cls):
        """Run the container"""
        cls.client = docker.from_env()
        image_name = helpers.get_image_name()
        cls.container = cls.client.containers.run(
            image=image_name,
            detach=True,
            stdin_open=True,
            environment = {"MLM_LICENSE_TOKEN": os.getenv("BATCH_TOKEN")},
        )
        cls.expected_ddux_force_enable = "true"
        cls.expected_ddux_tags = [
            "MATLAB:BATCHLICENSING:DOCKERFILE:V1",
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

    def test_matlabbatch_runs(self):
        """Test that matlab-batch runs successfully and that the matlab release is the correct one."""
        matlabbatch_cmd = 'matlab-batch "disp(version(\'-release\'))"'
        cmd_output = self.host.run(matlabbatch_cmd)
        self.assertTrue(
            cmd_output.succeeded,
            f"Unable to run matlab-batch correctly: {cmd_output.stdout}",
        )
        expectedRelease=self.release_tag.strip().lstrip("Rr")
        self.assertRegex(cmd_output.stdout, expectedRelease)

    def test_matlabbatch_version(self):
        """Test the version of matlab-batch installed in the container"""
        readme_filepath = "../alternates/non-interactive/MATLAB-BATCH.md"
        expected_version = helpers.get_changelog_mb_version(readme_filepath)
        expected_output = f"matlab-batch {expected_version} (glnxa64)"
        version_cmd = f"matlab-batch -version"
        self.assertEqual(
            expected_output,
            self.host.check_output(version_cmd),
            "Mismatching versions of matlab-batch in changelog",
        )


################################################################################

if __name__ == "__main__":
    unittest.main()
