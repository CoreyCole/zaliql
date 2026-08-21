const fs = require('fs');
const path = require('path');

const docsPath = path.join(__dirname, 'backend', 'docs.json');
const readmePath = path.join(__dirname, 'README.md');
const begin = '<!-- DOCS:BEGIN -->';
const end = '<!-- DOCS:END -->';

function stringify(value) {
  if (typeof value === 'string') return value;
  if (Array.isArray(value)) return value.map(stringify).join('\n');
  if (value && typeof value === 'object') return Object.keys(value).map(key => `- **${key}**: ${stringify(value[key])}`).join('\n');
  return String(value);
}

function renderDocs(docs) {
  const source = docs && typeof docs === 'object' && !Array.isArray(docs) && docs.functions && typeof docs.functions === 'object' ? docs.functions : docs;
  const entries = Array.isArray(source) ? source.map((doc, i) => [doc && doc.name ? doc.name : `Section ${i + 1}`, doc]) : Object.entries(source || {});
  const sections = entries.map(([name, value]) => `### ${name}\n\n${stringify(value)}`);
  return `## API Documentation\n\n${sections.join('\n\n')}\n\n`;
}

function main() {
  const docs = JSON.parse(fs.readFileSync(docsPath, 'utf8'));
  const generated = `${begin}\n${renderDocs(docs)}${end}\n`;
  let readme = fs.existsSync(readmePath) ? fs.readFileSync(readmePath, 'utf8') : '# ZaliQL\n';
  const i = readme.indexOf(begin);
  const j = readme.indexOf(end);
  if (i !== -1 && j !== -1) readme = readme.slice(0, i) + generated + readme.slice(j + end.length);
  else readme = readme.replace(/\s*$/, '') + `\n\n${generated}`;
  fs.writeFileSync(readmePath, readme);
}

main();
