// Copyright IBM Corp. 2013,2016. All Rights Reserved.
// Node module: loopback-oracle-builder
// US Government Users Restricted Rights - Use, duplication or disclosure
// restricted by GSA ADP Schedule Contract with IBM Corp.

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

var info = module.exports = {
  version: pkg.config.bundleVersion || pkg.version,
  platform: platforms[process.platform] || process.platform,
  arch: archs[process.arch] || 
    ((process.config.variables.node_byteorder == 'little' && process.arch == 'ppc64') ? 'leppc64' : process.arch),
  bundleVersion: pkg.config.bundleVersion || pkg.version,
  driverModule: pkg.config.driverModule,
  nodeModuleVersion: abi
};

if(require.main === module) {
  console.log(info.platform, info.arch, info.version, 
    info.bundleVersion, info.driverModule, info.nodeModuleVersion);
}
