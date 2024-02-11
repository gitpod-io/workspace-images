const os = require('os');

// Adapted from https://stackoverflow.com/a/71331716/10199319 (CC BY-SA 4.0)
function sortVersions(versionArray, reverse = false) {
  let semVerArr = versionArray.map(i => i.replace(/(\d+)/g, m => +m + 100000)).sort(); // +m is just a short way of converting the match to int
  if (reverse) {
    semVerArr = semVerArr.reverse();
  }

  return semVerArr.map(i => i.replace(/(\d+)/g, m => +m - 100000))
}

exports.register = async (fixers) => {
  const response = await fetch("https://raw.githubusercontent.com/endoflife-date/release-data/main/releases/python.json");
  const data = await response.json();

  const versions = sortVersions(Object.keys(data.versions));

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
    id: 'update-lang-python',
    cmd: Object.keys(patchVersionReplacements).map(pattern => {
      return `sed ${os.type() === 'Darwin' ? '-i "" -E' : '-i -e'} "s/\\(PYTHON_VERSION.*\\)${pattern}/\\1${patchVersionReplacements[pattern]}/g" chunks/lang-python/chunk.yaml`;
    }).join('\n'),
    description: 'update lang python',
  });
};
