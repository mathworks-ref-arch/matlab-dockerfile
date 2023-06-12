# Copyright 2023 The MathWorks, Inc.

"""Set of test utils functions."""

import os


def remove_file(filepath):
    """Remove the file with path FILEPATH"""
    try:
        os.remove(filepath)
    except OSError:
        pass


def get_build_output(docker_api_client, dockerfile_dirpath, release):
    """Get the output messages of docker build"""
    build_output = docker_api_client.build(
        path=dockerfile_dirpath,
        forcerm=True,
        buildargs={"MATLAB_RELEASE": release},
    )

    build_msg = [
        line.decode("utf-8").strip().removeprefix('{"stream":"').removesuffix('"}')
        for line in build_output
    ]

    return build_msg
