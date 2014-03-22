fs = require 'fs'
path = require 'path'

module.exports = (selectedDir, selectedFile, callback) ->
  fs.readdir selectedDir, (error, files) ->
    if error?
      console.error(error)
      return callback([])

    files = files.map (file) ->
      filePath = path.resolve "#{selectedDir}/#{file}"
      isDirectory = fs.statSync(filePath).isDirectory()
      urlPath = path.relative selectedDir, filePath

      fileName = file
      if isDirectory
        fileName += '/'
        urlPath += '/'

      metadata =
        link:
          content: fileName
          href: urlPath
      if selectedFile == filePath
        metadata['item@class'] = 'menu-item-divided pure-menu-selected'
      metadata

    callback(files)

