fs = require 'fs'
path = require 'path'

module.exports = (rootPath, relativePath, body, query, url, callback) ->
  localPath = path.join '..', 'public', relativePath
  selectedFile = path.resolve "#{__dirname}/../#{localPath}"

  content = body.content?.replace(/\r?\n/g, '\n')

  if query.action == 'new-dir'
    newDir = body['dir-name']
    url = url.split('?')[0]
    if url[url.length-1] != '/'
      url += '/'
    url += newDir + '/'

    if (fs.statSync selectedFile).isFile()
      selectedFile = path.dirname(selectedFile)
      urlDir = path.relative rootPath, selectedFile
      if urlDir.length > 0
        urlDir = '/' + urlDir
      url = urlDir + '/' + newDir

    selectedFile += "/#{newDir}"
    fs.mkdirSync selectedFile
    callback(url)

  else if query.action == 'new-file'
    newFile = body['file-name']
    url = url.split('?')[0] + "/#{newFile}"

    if (fs.statSync selectedFile).isFile()
      selectedFile = path.dirname(selectedFile)
      urlDir = path.relative rootPath, selectedFile
      if urlDir.length > 0
        urlDir = '/' + urlDir
      url = urlDir + '/' + newFile

    selectedFile += "/#{newFile}"
    fs.writeFileSync selectedFile, content
    callback(url)

  else
    fs.writeFileSync selectedFile, content
    callback(url.split('?')[0])

