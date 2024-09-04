workDir = setupExample(findExample('matlab/WriteATestForAnAppExample'));
cd(workDir)
assertSuccess(runtests("ConfigurePlotAppExampleTest"))
