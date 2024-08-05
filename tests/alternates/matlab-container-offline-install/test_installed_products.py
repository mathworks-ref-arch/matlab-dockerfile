# Copyright 2024 The MathWorks, Inc.

"""Test runner for the productsTest.m test file"""

from utils import dockertool
from pathlib import Path
import unittest


class TestInstalledProducts(unittest.TestCase):
    """A test runner class for the productsTest.m test file"""

    def run_matlab_test(self, m_filename):
        m_filepath = str(Path(__file__).parent.resolve() / m_filename)

        runner = dockertool.MATLABTestRunner(m_filepath)

        exit_code, error, logs = runner.run()
        self.assertEqual(exit_code, 0, logs)
        self.assertIsNone(error, logs)

    def test_installed_products(self):
        m_filename = "productsTest.m"
        self.run_matlab_test(m_filename)


if __name__ == "__main__":
    unittest.main()
