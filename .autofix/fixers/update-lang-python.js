const os = require('os');
const util = require('util');
const exec = util.promisify(require('child_process').exec);

exports.register = async (fixers) => {
  const { stdout, stderr } = await exec('pyenv update 2>&1 && pyenv install --list');
  if (stderr) {
    throw stderr;
  }

  const patchVersionReplacements = {};
  for (const line of stdout.split('\n').slice(1,-1)) {
    const match = line.trim().match(/^([a-z1-9\.]+-)?(\d+\.\d+\.)(\d+)$/);
    if (!match) {
      continue;
    }

    const pattern = ((match[1] || '') + match[2]).replace(/\./g, '\\.') + '[0-9][0-9]*';
    patchVersionReplacements[pattern] = match[0];
  }

  fixers[0].push({
    id: 'update-lang-python',
    cmd: Object.keys(patchVersionReplacements).map(pattern => {
        return `sed ${os.type() === 'Darwin' ? '-i "" -E' : '-i -e'} "s/\\(PYTHON_VERSION.*\\)${pattern}/\\1${patchVersionReplacements[pattern]}/g" chunks/lang-python/chunk.yaml`;
    }).join('\n'),
    description: 'update lang python',
  });
};
