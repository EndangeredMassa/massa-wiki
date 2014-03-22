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

