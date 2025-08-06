# Copyright 2025 The MathWorks, Inc.
# This script allows you to run build and test targets of a GitHub actions pipeline in an identical manner on your local machine.
# This ensures that the build and test actions are easily reproducible outside of a CI/CD pipeline.
param(
    [Parameter(Mandatory=$False, Position=1, ValueFromPipeline=$false)]
    [System.String]
    $Release = "R2025a",
    
    [Parameter(Mandatory=$False, Position=1, ValueFromPipeline=$false)]
    [System.String]
    $ProductList = "MATLAB Text_Analytics_Toolbox Simulink_Coder Embedded_Coder MATLAB_Support_for_MinGW-w64_C/C++/Fortran_Compiler Requirements_Toolbox",
    
    [Parameter(Mandatory=$False, Position=1, ValueFromPipeline=$false)]
    [System.String]
    $Token = "",
    
    [Parameter(Mandatory=$False, Position=1, ValueFromPipeline=$false)]
    [System.String]
    $Target = "BuildAndTest"
)

$script:ImageName="mathworks/matlab-on-windows"
$script:Version="0.5.1"

function Build {
        $Tag = ${Release}.ToLower() + "_" + ${Version}
        & docker build --build-arg MATLAB_RELEASE=${Release} --build-arg MATLAB_PRODUCT_LIST="${ProductList}" -t "${ImageName}:${Tag}" .
}

function Test {
        if (${Token} -eq "") {
            Write-Error "Token argument must be supplied to test command"
            throw "input error"
        }
        $Tag = ${Release}.ToLower() + "_" + ${Version}
	$container = New-PesterContainer -Path .\test\Test-MATLABWindowsContainer.tests.ps1 -Data @{ Release = ${Release}; ImageName = "${ImageName}:${Tag}"; Token = ${Token} }
        & Invoke-Pester -Container $container -Output Detailed
}

function BuildAndTest {
    Build
    Test
}

switch (${Target}) {
    'Build' { Build }
    'Test' { Test }
    'BuildAndTest' { BuildAndTest }
    default { BuildAndTest }
}
