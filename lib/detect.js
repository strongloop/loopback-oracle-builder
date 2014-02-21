var pkg = require('../version.json');

var platforms = {
    darwin: 'MacOSX',
    linux: 'Linux',
    win32: 'Windows'
}

var archs = {
    ia32: 'x86',
    x64: 'x64'
}

var info = module.exports = {
  version: pkg.version,
  platform: platforms[process.platform] || process.platform,
  arch: archs[process.arch] || process.arch,
  driverVersion: pkg.driverVersion
};

if(require.main === module) {
  console.log(info.platform, info.arch, info.version, info.driverVersion);
}
