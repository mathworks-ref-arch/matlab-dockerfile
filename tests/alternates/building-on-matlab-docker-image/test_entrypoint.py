# Copyright 2023 The MathWorks, Inc.

"""
Test class to validate the entrypoint options of the "building-on-matlab-docker-image" Dockerfile.

This test suite will launch the container with all different options.
"""

from utils import helpers
import docker
import testinfra
import unittest

################################################################################


class TestEntrypoint(unittest.TestCase):
    """Extend the test methods of the base TestCase class."""

    @classmethod
    def setUpClass(cls):
        """Set up the test class."""
        cls.client = docker.from_env()
        cls.image_name = helpers.get_image_name()

    @classmethod
    def tearDownClass(cls):
        """Close the docker client"""
        cls.client.close()

    def setUp(self):
        """Define an empty container object, so that we can call stop() and remove() in the tearDown method"""
        self.container = docker.models.containers.Container()

    def tearDown(self):
        """Stop and remove the container"""
        self.container.stop()
        self.container.remove()

    ############################################################################

    def test_no_entry_option(self):
        """Test that if no entry option is specified then the interactive login is started"""
        expected_login_msg = (
            "Please enter your MathWorks Account email address and press Enter:"
        )
        self.container = self.client.containers.run(
            image=self.image_name,
            detach=True,
            stdin_open=True,
        )
        helpers.wait_for_msg_in_log(self.container, expected_login_msg)
        self.assertIn(expected_login_msg, self.container.logs(tail=1).decode())

    def test_shell_option(self):
        """Test that if the '-shell' option is specified, then a '/bin/bash' process is started"""
        expected_shell = "/bin/bash"
        self.container = self.client.containers.run(
            image=self.image_name,
            detach=True,
            stdin_open=True,
            command="-shell",
        )
        host = testinfra.get_host("docker://" + self.container.id)
        helpers.wait_for_cmd(self.container, expected_shell)

        running_procs = host.check_output("ps -x -o cmd")
        self.assertIn(expected_shell, running_procs)

    def test_vnc_option(self):
        """Test that if the '-vnc' option is specified, then a vncserver is started in the container."""
        expected_port = "5901"
        self.container = self.client.containers.run(
            image=self.image_name,
            detach=True,
            stdin_open=True,
            command="-vnc",
        )
        host = testinfra.get_host("docker://" + self.container.id)
        helpers.wait_for_cmd(self.container, "vnc", 30)

        vnc_list_cmd = f"/usr/bin/vncserver -list -rbfport {expected_port}"
        # run "vncserver -list -rbfport 5901" in the Docker container
        vnc_list_output = host.check_output(vnc_list_cmd)
        # the output of "vncserver -list -rbfport 5901" is a text containing a
        # tab-separated table, e.g.
        #
        # TigerVNC server sessions:
        #
        # X DISPLAY #     RFB PORT #      RFB UNIX PATH   PROCESS ID #    SERVER
        # 1               5901                            34              Xtigervnc
        #
        # table_lines will extract the lines in the table above (including the title line)
        table_lines = list(
            filter(lambda line: "\t" in line, vnc_list_output.split("\n"))
        )
        self.assertRegex(
            table_lines[-1],
            expected_port,
            f"command {vnc_list_cmd} returned:\n{vnc_list_output}",
        )

    def test_browser_option(self):
        """Test that if the '-browser' option is specified, then matlab-proxy-app is running"""
        matlab_proxy_process = "matlab-proxy-app"
        self.container = self.client.containers.run(
            image=self.image_name,
            detach=True,
            stdin_open=True,
            command="-browser",
        )
        host = testinfra.get_host("docker://" + self.container.id)
        helpers.wait_for_cmd(self.container, matlab_proxy_process)

        running_procs = host.check_output("ps -x -o cmd")
        self.assertIn(matlab_proxy_process, running_procs)

    def test_batch_option(self):
        """Test that if the '-batch' option is specified with a license file, then MATLAB runs in batch mode."""
        source_lic_filepath = helpers.get_license_filepath()
        lic_filepath = "/tmp/license.lic"
        mount = [
            docker.types.Mount(
                target=lic_filepath,
                source=source_lic_filepath,
                type="bind",
            ),
        ]
        cmd = f"-batch \"disp('Hello World');\
            pause(Inf);\""  # pause(Inf) to keep the container running
        env = {"MLM_LICENSE_FILE": lic_filepath}

        self.container = self.client.containers.run(
            image=self.image_name,
            detach=True,
            environment=env,
            mounts=mount,
            command=cmd,
        )
        host = testinfra.get_host("docker://" + self.container.id)
        helpers.wait_for_cmd(self.container, "MATLAB")

        self.assertGreater(len(host.process.filter(user="matlab", comm="MATLAB")), 0)

    def test_custom_option(self):
        """Test that if a custom option is specified, the custom command is run in bash."""
        custom_option = "pwd"
        expected_output = "/home/matlab"

        self.container = self.client.containers.run(
            image=self.image_name,
            detach=True,
            command=custom_option,
        )
        self.container.wait()

        self.assertEqual(self.container.logs().decode().strip(), expected_output)


################################################################################

if __name__ == "__main__":
    unittest.main()
