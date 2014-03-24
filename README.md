# massa-wiki

This is a simple file-based
markdown wiki.
Existing tools were too complex
and/or too broken to for my use.

```coffeescript
wiki = require 'massa-wiki'

docPath = "#{__dirname}/docs"
port = 8000
wiki.start port, docPath
```

The code found herein isn't great.
Use it at your own risk!

## to do

- sort dirs/files (dirs first, then files; alpha sort)
- autoselect index.md when navigating to a dir
- fix error when creating new file at root (navigates without root url)
- auto git commit + git push

## to don't

- delete file/dir
- move file/dir

## license

[MIT](LICENSE)
