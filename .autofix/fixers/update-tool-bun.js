const os = require('os');

exports.register = async (fixers) => {
  const response = await fetch("https://api.github.com/repos/oven-sh/bun/releases/latest");
  const data = await response.json();
  const version = data.tag_name.split("-v")[1];

  const patchVersionReplacements = {
    '1\\.[0-9][0-9]*\\.[0-9][0-9]*': version,
  }

  fixers[0].push({
    id: 'update-tool-bun',
    cmd: Object.keys(patchVersionReplacements).map(pattern => {
      return `sed ${os.type() === 'Darwin' ? '-i "" -E' : '-i -e'} "s/\\(BUN_VERSION.*\\)${pattern}/\\1${patchVersionReplacements[pattern]}/g" chunks/tool-bun/chunk.yaml`;
    }).join('\n'),
    description: 'update tool bun',
  });
};
