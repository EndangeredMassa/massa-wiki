marked = require 'marked'

marked.setOptions
  gfm: true
  tables: true
  pedantic: false
  sanitize: false
  smartLists: true

module.exports = (content) ->
  if content[0..3] == '---\n'
    stop = content[3..].indexOf('---') + 1
    frontMatter = content[4..stop]
    content = content[(stop+6)..]

  marked(content)

