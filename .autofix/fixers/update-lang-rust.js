const os = require('os');

const register = async (fixers) => {
  const response = await fetch("https://api.github.com/repos/rust-lang/rust/releases/latest");
  const data = await response.json();
  const version = data.tag_name;

  const patchVersionReplacements = {
    '1\\.[0-9][0-9]*\\.[0-9][0-9]*': version,
  }

  fixers[0].push({
    id: 'update-lang-rust',
    cmd: Object.keys(patchVersionReplacements).map(pattern => {
      return `sed ${os.type() === 'Darwin' ? '-i "" -E' : '-i -e'} "s/\\(RUST_VERSION.*\\)${pattern}/\\1${patchVersionReplacements[pattern]}/g" chunks/lang-rust/chunk.yaml`;
    }).join('\n'),
    description: 'update lang rust',
  });
};

exports.register = register
