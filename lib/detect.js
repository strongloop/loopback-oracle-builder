var pkg = require('../package.json');

var platforms = {
    darwin: 'MacOSX',
    linux: 'Linux',
    win32: 'Windows'
}

var archs = {
    ia32: 'x86',
    x64: 'x64'
}

var abi = process.versions.modules;
if(pkg.config.excludeAbi === true || pkg.config.excludeAbi === abi) {
  abi = undefined;
}
var info = module.exports = {
  version: pkg.config.bundleVersion || pkg.version,
  platform: platforms[process.platform] || process.platform,
  arch: archs[process.arch] || process.arch,
  bundleVersion: pkg.config.bundleVersion || pkg.version,
  driverModule: pkg.config.driverModule,
  nodeModuleVersion: abi
};

if(require.main === module) {
  console.log(info.platform, info.arch, info.version, 
    info.bundleVersion, info.driverModule, info.nodeModuleVersion);
}
