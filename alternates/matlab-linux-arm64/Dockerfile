# Copyright 2026 The MathWorks, Inc.
#
# Builds a Docker® image containing the Linux® ARM64 build of MATLAB® on a prebuilt
# matlab-deps base image. MATLAB can be installed at build time (place the tar.gz archive in
# the matlab-archive folder) or mounted at run time (build with no archive present). For
# build options, base images, and run instructions, see README.md.

# To build on a different operating system,
# set OS to one of the published tags (see README.md).
ARG OS=ubuntu26.04

# MATLAB R2026b is the only release available for Linux ARM64 Beta.
ARG MATLAB_RELEASE=R2026b

ARG BASE_IMAGE=ghcr.io/mathworks-ref-arch/container-images/matlab-deps-arm64:${MATLAB_RELEASE}-${OS}
FROM ${BASE_IMAGE}

# Name of the MATLAB ARM64 archive to unpack, expected in the matlab-archive folder.
ARG MATLAB_TGZ=MATLABR2026b_OpenBeta_aarch64_v3.1.1.tar.gz
ARG PIP_INDEX_URL


# Install the extra packages needed on top of matlab-deps, detecting the package manager.
# On Ubuntu/Debian also install matlab-proxy for the browser desktop; Red Hat UBI is
# command-line only.
RUN set -e; \
    if command -v apt-get >/dev/null 2>&1; then \
        export DEBIAN_FRONTEND=noninteractive; \
        apt-get update; \
        apt-get install --no-install-recommends --yes \
            ca-certificates wget sudo xvfb openbox fluxbox python3 python3-pip python3-venv pipx; \
        apt-get clean; \
        apt-get --yes autoremove; \
        rm -rf /var/lib/apt/lists/*; \
        export PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin; \
        if [ -n "${PIP_INDEX_URL}" ]; then export PIP_INDEX_URL="${PIP_INDEX_URL}"; fi; \
        pipx install matlab-proxy; \
    elif command -v dnf >/dev/null 2>&1 || command -v yum >/dev/null 2>&1; then \
        PKG="$(command -v dnf || command -v yum)"; \
        "${PKG}" install --disableplugin=subscription-manager --assumeyes sudo; \
        "${PKG}" clean all; \
    else \
        echo "No supported package manager (apt-get, dnf, or yum) found." >&2; \
        exit 1; \
    fi

# Add a non-root "matlab" user with passwordless sudo.
RUN useradd --create-home --shell /bin/bash matlab \
    && echo "matlab ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/matlab \
    && chmod 0440 /etc/sudoers.d/matlab


# Unpack MATLAB if the archive is present; otherwise build an image that expects MATLAB to be
# mounted at /opt/matlab at run time. The install location is release-agnostic, so it does not
# change between MATLAB releases. The matlab-archive folder is bind-mounted (not COPYed) so
# the build still succeeds when the archive is absent and the multi-gigabyte archive never
# becomes an image layer. The symlink is created unconditionally; it resolves once MATLAB is
# present at build time or mounted at run time.
RUN --mount=type=bind,source=matlab-archive,target=/tmp/matlab-archive \
    install_location=/opt/matlab; \
    mkdir -p "${install_location}" \
    && if [ -f "/tmp/matlab-archive/${MATLAB_TGZ}" ]; then \
        echo "Unpacking ${MATLAB_TGZ} into ${install_location}"; \
        tar -xf "/tmp/matlab-archive/${MATLAB_TGZ}" -C "${install_location}"; \
    else \
        echo "No MATLAB archive found in matlab-archive; building an image without MATLAB installed."; \
        echo "Mount MATLAB at ${install_location} when you run the container."; \
    fi \
    && ln -s "${install_location}/bin/matlab" /usr/local/bin/matlab

USER matlab
WORKDIR /home/matlab/Documents/MATLAB

# Opt out of user-experience data collection by removing this line (see README).
ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=MATLAB:ARM64:DOCKERFILE:V1

# matlab-proxy configuration
ENV MWI_ENABLE_TOKEN_AUTH=false
ENV MWI_BASE_URL=/
ENV MWI_APP_PORT=8888
ENV MWI_USE_EXISTING_LICENSE=True
EXPOSE 8888

ENTRYPOINT ["matlab"]
CMD [""]
