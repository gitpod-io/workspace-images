const os = require('os');

exports.register = async (fixers) => {
  const response = await fetch("https://raw.githubusercontent.com/actions/go-versions/main/versions-manifest.json");
  const data = await response.json();

  const versions = data.filter(version => version.stable).flatMap(version => version.version).reverse();

  const patchVersionReplacements = {};
  for (const version of versions) {
    const match = version.match(/^(\d+\.\d+)\.(\d+)$/);
    if (!match) {
      continue;
    }
    // Only capturing major and minor versions in the pattern
    const segments = version.split('.');
    const prefix = segments.slice(0, -1).join('\\.');
    const pattern = prefix + '\\.[0-9][0-9]*';
    patchVersionReplacements[pattern] = version;
  }

  fixers[0].push({
    id: 'update-lang-go',
    cmd: Object.keys(patchVersionReplacements).map(pattern => {
      return `sed ${os.type() === 'Darwin' ? '-i "" -E' : '-i -e'} "s/\\(GO_VERSION.*\\)${pattern}/\\1${patchVersionReplacements[pattern]}/g" chunks/lang-go/chunk.yaml`;
    }).join('\n'),
    description: 'update lang go',
  });
};
