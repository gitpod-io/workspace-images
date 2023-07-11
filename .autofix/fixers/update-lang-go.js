const os = require('os');
const util = require('util');
const exec = util.promisify(require('child_process').exec);

exports.register = async (fixers) => {
  const { stdout, stderr } = await exec('gvm listall');
  if (stderr) {
    throw stderr;
  }

  const patchVersionReplacements = {};
  for (const line of stdout.split('\n').slice(1,-1)) {
    const match = line.trim().match(/^go(\d+\.\d+\.)(\d+)$/);
    if (!match) {
      continue;
    }

    const pattern = match[1].replace(/\./g, '\\.') + '[0-9][0-9]*';
    patchVersionReplacements[pattern] = 'go' + match[1] + match[2];
  }

  fixers[0].push({
    id: 'update-lang-go',
    cmd: Object.keys(patchVersionReplacements).map(pattern => {
        return `sed ${os.type() === 'Darwin' ? '-i "" -E' : '-i -e'} "s/\\(GO_VERSION.*\\)${pattern}/\\1${patchVersionReplacements[pattern]}/g" chunks/lang-go/chunk.yaml`;
    }).join('\n'),
    description: 'update lang go',
  });
};
