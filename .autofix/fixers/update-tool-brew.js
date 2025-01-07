const os = require('os');

const register = async (fixers) => {
    const response = await fetch("https://api.github.com/repos/homebrew/brew/releases/latest");
    const data = await response.json();
    const version = data.tag_name;

    const patchVersionReplacements = {
        '4\\.[0-9][0-9]*\\.[0-9][0-9]*': version,
    }

    fixers[0].push({
        id: 'update-tool-brew',
        cmd: Object.keys(patchVersionReplacements).map(pattern => {
            return `sed ${os.type() === 'Darwin' ? '-i "" -E' : '-i -e'} "s/\\(TRIGGER_REBUILD.*\\)${pattern}/\\1${patchVersionReplacements[pattern]}/g" chunks/tool-brew/Dockerfile`;
        }).join('\n'),
        description: 'update tool brew',
    });
};

exports.register = register
