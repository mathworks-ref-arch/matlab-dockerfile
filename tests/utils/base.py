# Copyright 2023 The MathWorks, Inc.

"""
Base class for Docker tests.
"""

import stat
import testinfra
import unittest


class TestCase(unittest.TestCase):
    """Base test class for Docker tests"""

    undesired_status = ["removing", "exited", "dead"]

    @classmethod
    def setUpClass(cls):
        """Get the host field in the class."""
        cls.host = testinfra.get_host("docker://" + cls.container.id)

    def setUp(self):
        """Fail if the container is not running."""
        self.assertNotIn(
            self.container.status,
            self.undesired_status,
            f"Container {self.container.name} is in '{self.container.status}' status",
        )

    def tearDown(self):
        """Fail if the container is not running."""
        self.assertNotIn(
            self.container.status,
            self.undesired_status,
            f"Container {self.container.name} is in '{self.container.status}' status",
        )

    ############################################################################

    ## User-related tests

    def test_current_user_name(self):
        """Test that the current user is 'matlab'."""
        expected_user = "matlab"
        self.assertEqual(self.host.user().name, expected_user)

    def test_current_user_shell(self):
        """Test that the current user has bash as current shell."""
        expected_shell = "/bin/bash"
        self.assertEqual(self.host.user().shell, expected_shell)

    def test_current_user_has_sudo(self):
        """Test that the current user has sudo permission."""
        cmd = "sudo echo 'Hello World'"
        self.assertTrue(self.host.run(cmd).succeeded)

    def test_users(self):
        """Test that the expected users exist."""
        root_username = "root"
        self.assertTrue(self.host.user(root_username).exists)

    ## Packages-related tests

    def test_matlab_deps_packages_installed(self):
        """Test that packages installed in matlab-deps are persisted in the tested image."""
        # get the packages installed in the matlab-deps image
        matlab_deps_image = f"mathworks/matlab-deps:{self.release_tag}"
        cmd = ["apt-cache", "pkgnames"]
        expected_packages = self.client.containers.run(
            image=matlab_deps_image, remove=True, command=cmd
        )
        expected_package_list = expected_packages.decode().split()
        for pkg in expected_package_list:
            with self.subTest(package=pkg):
                self.assertTrue(
                    self.host.package(pkg).is_installed,
                    f"package {pkg} is not installed",
                )

    def test_apt_cache_is_clean(self):
        """Test that the apt cache got cleaned after package installations."""
        self.assertSetEqual(
            set(self.host.file("/var/cache/apt/archives").listdir()),
            {"lock", "partial"},
        )

    ## MATLAB-related tests

    def test_matlab_is_on_path(self):
        """Test that matlab is on PATH."""
        self.assertTrue(self.host.run("which matlab").succeeded)

    def test_matlab_executable(self):
        """Test that the matlab file is executable."""
        matlab_executable_path = self.host.check_output(
            "which matlab | xargs readlink -f"
        ).rstrip("\n")
        self.assertRegex(
            stat.filemode(stat.S_IMODE(self.host.file(matlab_executable_path).mode)),
            "r.xr-xr-x",
        )

    def test_install_dir_absent(self):
        """Test that the temporary installation directory is removed."""
        install_dirname = self.install_dirname
        directories = ("/", "/tmp", "/usr/share", "/usr/local", "/usr/bin")
        for dirname in directories:
            with self.subTest(dirname=dirname):
                self.assertNotIn(install_dirname, self.host.file(dirname).listdir())

    ## DDUX-related tests

    def test_ddux_force_enable(self):
        """Test that the DDUX environment variable MW_DDUX_FORCE_ENABLE is set correctly."""
        expected_ddux_force_enable = self.expected_ddux_force_enable
        mw_ddux_force_enable = self.host.environment().get("MW_DDUX_FORCE_ENABLE")
        self.assertEqual(mw_ddux_force_enable, expected_ddux_force_enable)

    def test_ddux_tags(self):
        """Test that the DDUX environment variable MW_CONTEXT_TAGS is set correctly."""
        expected_ddux_tags = self.expected_ddux_tags
        mw_context_tags = self.host.environment().get("MW_CONTEXT_TAGS")
        for expected_tag in expected_ddux_tags:
            with self.subTest(ddux_tag=expected_tag):
                self.assertIn(expected_tag, mw_context_tags)
