% run the tests for Travis CI
%
% File system looks like this:
%    robotics-toolbox-matlab
%    robotics-toolbox-matlab/unit_test  ** WORKING folder
%	 lib/toolbox-common
%    lib/spatial-math-toolbox

import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.codecoverage.CoberturaFormat
import matlab.unittest.TestRunner

suite = testsuite('IncludeSubfolders', false);
runner = TestRunner.withTextOutput;

% do a coverage report
reportFile = fullfile('..', 'coverage.xml');
reportFormat = CoberturaFormat(reportFile);
plugin = CodeCoveragePlugin.forFolder('..', 'Producing',reportFormat);
runner.addPlugin(plugin);

% setup the path

% for other toolboxes
addpath ../../lib/toolbox-common-matlab
addpath ../../lib/spatial-math

% for RTB
addpath ..
addpath ../models
addpath ../data
addpath ../simulink

% build the MEX file
cd ../mex
make
cd ..

% Run all unit tests in my repository.
results = runner.run(suite);

% Assert no tests failed.
assert(all(~[results.Failed]));
