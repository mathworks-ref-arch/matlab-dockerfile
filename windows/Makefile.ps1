# Copyright 2025 The MathWorks, Inc.
# This script allows you to run build and test targets of a GitHub actions pipeline in an identical manner on your local machine.
# This ensures that the build and test actions are easily reproducible outside of a CI/CD pipeline.
param(
    [Parameter(Mandatory=$False, Position=0, ValueFromRemainingArguments=$false)]
    [System.String]
    $Target = "BuildAndTest",

    [Parameter(Mandatory=$False, ValueFromPipeline=$false)]
    [System.String]
    $ImageName = "matlab-on-windows",

    [Parameter(Mandatory=$False, ValueFromPipeline=$false)]
    [System.String]
    $Release = "R2025b",
    
    [Parameter(Mandatory=$False, ValueFromPipeline=$false)]
    [System.String]
    $ProductList = "MATLAB Text_Analytics_Toolbox Simulink_Coder Embedded_Coder MATLAB_Support_for_MinGW-w64_C/C++/Fortran_Compiler Requirements_Toolbox",
    
    [Parameter(Mandatory=$False, ValueFromPipeline=$false)]
    [System.String]
    $Token = ""
)

$script:Version="0.6.0"

function defaultTag {
    return (Get-Culture).TextInfo.ToTitleCase(${Release})
}

function additionalTags {
    return @(${Release}.ToLower())
}

function Build {
    $Tag = defaultTag
    & docker build --isolation=hyperv --build-arg MATLAB_RELEASE=${Release} --build-arg MATLAB_PRODUCT_LIST="${ProductList}" -t "${ImageName}:${Tag}" .
}

function Test {
    if (${Token} -eq "") {
        Write-Error "Token argument must be supplied to test command"
        throw "input error"
    }
    $Tag = defaultTag
	$container = New-PesterContainer -Path .\test\Test-MATLABWindowsContainer.tests.ps1 -Data @{ Release = ${Release}; ImageName = "${ImageName}:${Tag}"; Token = ${Token} }
    & Invoke-Pester -Container $container -Output Detailed
}

function TagImage {
    $DefaultTag = defaultTag
    $AdditionalTags = additionalTags

    foreach ($Tag in $AdditionalTags) {
        & docker tag "${ImageName}:${DefaultTag}" "${ImageName}:${Tag}"
    }
}

function Publish {
    docker push --all-tags ${ImageName}
}

function BuildAndTest {
    Build
    Test
}

switch (${Target}) {
    'Build' { Build }
    'Test' { Test }
    'BuildAndTest' { BuildAndTest }
    'TagImage' { TagImage }
    'Publish' {Publish}
    default { BuildAndTest }
}
