const os = require('os');
const util = require('util');
const exec = util.promisify(require('child_process').exec);

exports.register = async (fixers) => {
  const { stdout, stderr } = await exec('bash -lc ". ~/.nvm/nvm.sh && nvm ls-remote --no-colors"');
  if (stderr) {
    throw stderr;
  }

  const minorVersionReplacements = {};
  for (const line of stdout.split('\n')) {
    const match = line.trim().match(/^[->]*\s*([a-z1-9\.]+-)?v(\d+\.)(\d+\.\d+)\s*.*$/);
    if (!match || match[2] === '0.') {
      // Unsupported format, or unsupported version (e.g. Node.js v0).
      continue;
    }

    const prefix = match[1] ? match[1] + 'v' : '';
    const pattern = (prefix + match[2]).replace(/\./g, '\\.') + '[0-9][0-9]*\\.[0-9][0-9]*';
    minorVersionReplacements[pattern] = prefix + match[2] + match[3];
  }

  fixers[0].push({
    id: 'upgrade-lang-node',
    cmd: Object.keys(minorVersionReplacements).map(pattern => {
        return `sed ${os.type() === 'Darwin' ? '-i "" -E' : '-i -e'} "s/\\(NODE_VERSION.*\\)${pattern}/\\1${minorVersionReplacements[pattern]}/g" chunks/lang-node/chunk.yaml`;
      }).join('\n'),
    description: 'update lang-node',
  });
}
