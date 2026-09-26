// conventional-changelog settings for one app of a repository that tags each app on its
// own, as <prefix><version>+<build> (for example ios/0.2.0+2). Used with the
// conventionalcommits preset:
//
//   conventional-changelog -p conventionalcommits -n changelog.config.cjs \
//     -c context.json -t ios/ --commit-path . -r 1 -i CHANGELOG.md -s
//
// Only the heading changes: "0.2.0 (2)" instead of "0.2.0+2", and the local date.
// Set PREFIX to the app's tag prefix.
const { execFileSync } = require('child_process')

const PREFIX = 'ios/'

const local = (d) => {
  const t = new Date(d)
  return `${t.getFullYear()}-${String(t.getMonth() + 1).padStart(2, '0')}-${String(t.getDate()).padStart(2, '0')}`
}

// The app's release tags, newest first.
const tags = () =>
  execFileSync('git', ['tag', '-l', `${PREFIX}*`, '--sort=-creatordate'], { encoding: 'utf8' }).split('\n').filter(Boolean)

// The preset's template (conventional-changelog-conventionalcommits 8.0.0), with a blank
// line after each entry so an entry written above the last one stays apart from it.
const mainTemplate = [
  '{{> header}}',
  '{{#if noteGroups}}',
  '{{#each noteGroups}}',
  '',
  '### ⚠ {{title}}',
  '',
  '{{#each notes}}',
  '* {{#if commit.scope}}**{{commit.scope}}:** {{/if}}{{text}}',
  '{{/each}}',
  '{{/each}}',
  '{{/if}}',
  '{{#each commitGroups}}',
  '',
  '{{#if title}}',
  '### {{title}}',
  '',
  '{{/if}}',
  '{{#each commits}}',
  '{{> commit root=@root}}',
  '{{/each}}',
  '{{/each}}',
  '',
  '',
].join('\n')

module.exports = {
  writerOpts: {
    mainTemplate,
    // Replaces the core's, so it also finds the two tags the heading's compare link needs.
    finalizeContext(context, options, commits, keyCommit, originalCommits) {
      const raw = String(context.version || '')
      const all = tags()
      const tagged = keyCommit && new RegExp(`tag:\\s*(${PREFIX.replace('/', '\\/')}[^,)]+)`).exec(keyCommit.gitTags || '')
      context.currentTag = tagged ? tagged[1] : `${PREFIX}${raw}`
      context.previousTag = (tagged ? all[all.indexOf(tagged[1]) + 1] : all[0])
        // The first release compares from the first commit it carries.
        || (originalCommits.length ? originalCommits[originalCommits.length - 1].hash : undefined)
      context.linkCompare = Boolean(context.previousTag)
      // A tag's version is <version>+<build>; the heading reads "0.2.0 (2)".
      context.version = raw.replace(/^(.*)\+(\d+)$/, '$1 ($2)')
      // The day the release was tagged where it was tagged, not in UTC.
      context.date = local(keyCommit && keyCommit.committerDate ? keyCommit.committerDate : Date.now())
      return context
    },
  },
}
