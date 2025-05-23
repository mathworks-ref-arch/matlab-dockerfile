%   Copyright 2023-2025 The MathWorks, Inc.

classdef productsTest < matlab.unittest.TestCase


    methods(Test)
        function testInstalledToolboxesMatchExpected( testCase )
            import matlab.unittest.constraints.IsSameSetAs

            % names of the expected toolboxes
            expectedTbxNames = [...
                "Deep Learning Toolbox",...
                "Symbolic Math Toolbox"...
                ];

            if ~ isMATLABReleaseOlderThan("R2025a")
                expectedTbxNames = [expectedTbxNames, ...
                    "Deep Learning Toolbox Model for ResNet-50 Network", ...
                    ];
            end

            installedTbxNames = matlab.addons.installedAddons().Name;
            testCase.verifyThat(installedTbxNames, IsSameSetAs(expectedTbxNames));
        end
        function testInstalledSupportPackagesMatchExpected( testCase )
            import matlab.unittest.constraints.IsSameSetAs

            % names of the expected support packages
            expectedSpkgNames = [...
                "Deep Learning Toolbox Model for ResNet-50 Network"...
                ];
            installedSpkgNames = matlabshared.supportpkg.getInstalled().Name;
            testCase.verifyThat(installedSpkgNames, IsSameSetAs(expectedSpkgNames));
        end
    end
end
