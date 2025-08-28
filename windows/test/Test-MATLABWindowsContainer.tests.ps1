# Copyright 2025 The MathWorks, Inc.
# Requires v5.0 of pester 

param (
    [Parameter(Mandatory)]
    [string] $ImageName,

    [Parameter(Mandatory)]
    [string] $Token,

    [Parameter(Mandatory)]
    [string] $Release
)

Describe "MATLAB Docker Container Tests" {
    It "Runs rand() and returns expected output" {
        $result = docker run --isolation=hyperv -e "MLM_LICENSE_TOKEN=$Token" --rm "$ImageName" "matlab-batch.exe" "'rand()'"
        $LASTEXITCODE | Should -Be 0
        $result -join "`n" | Should -Match "0.8147"
    }

    It "Runs ver and includes release string" {
        $result = docker run --isolation=hyperv -e "MLM_LICENSE_TOKEN=$Token" --rm "$ImageName" "matlab-batch.exe" "'ver'"
        $LASTEXITCODE | Should -Be 0
        $result -join "`n" | Should -Match $Release
    }

    It "Runs peaks and returns expected expression" {
        $result = docker run --isolation=hyperv -e "MLM_LICENSE_TOKEN=$Token" --rm "$ImageName" "matlab-batch.exe" "'peaks'"
        $LASTEXITCODE | Should -Be 0
        $result -join "`n" | Should -Match "z =  3\*\(1-x\)\.\^2\.\*exp\(-\(x\.\^2\) - \(y\+1\)\.\^2\)"
    }

    It "Creates a plot and confirms file existence" {
        $result = docker run --isolation=hyperv -e "MLM_LICENSE_TOKEN=$Token" --rm "$ImageName" "matlab-batch.exe" '"figure; annotation(''ellipse'',  [.2 .2 .2 .2]); saveas(gcf, ''plot.png''); isfile(''plot.png'')"'
        $LASTEXITCODE | Should -Be 0
        $result -join "`n" | Should -BeLike "*ans =*logical*1*"
    }
}
