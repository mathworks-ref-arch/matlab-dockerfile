# Copyright 2023 The MathWorks, Inc.

"""Test runner for the toolboxesTest.m test file"""

from utils import dockertool
from pathlib import Path
import unittest


class TestInstalledToolboxes(unittest.TestCase):
    """A test runner class for the toolboxesTest.m test file"""

    def test_installed_toolboxes(self):
        m_filename = "toolboxesTest.m"
        m_filepath = str(Path(__file__).parent.resolve() / m_filename)

        runner = dockertool.MATLABTestRunner(m_filepath)

        exit_code, error, logs = runner.run()
        self.assertEqual(exit_code, 0, logs)
        self.assertIsNone(error, logs)


if __name__ == "__main__":
    unittest.main()
