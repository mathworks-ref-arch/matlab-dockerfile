%   Copyright 2023 The MathWorks, Inc.

classdef toolboxesTest < matlab.unittest.TestCase


    methods(Test)
        function testInstalledToolboxesMatchExpected( testCase )
            import matlab.unittest.constraints.IsSameSetAs

            % names of the expected toolboxes
            expectedTbxNames = [...
                "Statistics and Machine Learning Toolbox",...
                "Symbolic Math Toolbox"...
                ];
            installedTbxNames = matlab.addons.installedAddons().Name;
            testCase.verifyThat(installedTbxNames, IsSameSetAs(expectedTbxNames));
        end
    end
end