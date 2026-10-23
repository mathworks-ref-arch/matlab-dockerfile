# MATLAB Linux ARM64 Archive

To build an image with the Linux® ARM64 build of MATLAB® installed, place the MATLAB
archive in this folder before building the Dockerfile in the parent directory. To build an
image without MATLAB installed, leave this folder without an archive.

For how to get the archive and build the image, see
[Build Your Own Image](../README.md#build-your-own-image) in the parent README.

## Add the archive

Copy the downloaded `.tar.gz` file (for example `MATLABR2026b_OpenBeta_aarch64_v3.1.1.tar.gz`)
into this `matlab-archive` folder, next to this README. Do not extract it.

The folder should then contain the archive:

```
matlab-archive/
├── README.md
└── MATLABR2026b_OpenBeta_aarch64_v3.1.1.tar.gz
```

## Notes

- The archive is a complete MATLAB root. The Dockerfile extracts it directly into the
  MATLAB install location (`/opt/matlab`).
- If the archive filename differs from the default, pass it to the build with
  `--build-arg MATLAB_TGZ=<filename>`.
- The `.gitignore` in this folder keeps the archive out of version control. Only this
  README is tracked, so the folder ships empty.


----

Copyright 2026 The MathWorks, Inc.

----
