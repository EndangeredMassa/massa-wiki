fs = require 'fs'
path = require 'path'

scanDir = require './scan_dir'
compileMarkdown = require './markdown'


cheerio = require 'cheerio'
facile = require 'facile'
compile = (template, context) ->
  facile(template, context, cheerio)


requireFile = (file) ->
  (fs.readFileSync file).toString()

requireTemplate = (file) ->
  requireFile("#{__dirname}/#{file}")

module.exports = (rootPath, relativePath, query, callback) ->
  localPath = path.join '..', 'public', relativePath
  absolutePath = path.resolve "#{__dirname}/../#{localPath}"

  selectedFile = null
  selectedDir = absolutePath
  if (fs.statSync absolutePath).isFile()
    selectedFile = absolutePath
    selectedDir = path.dirname(absolutePath)


  back =
    link:
      content: '..'
      href: '..'

  navlist = []

  isRoot = selectedDir == rootPath
  if !isRoot
    navlist.push(back)

  scanDir selectedDir, selectedFile, (files) ->
    navlist = navlist.concat(files)

    title = relativePath
    context =
      navlist: navlist

    if query.action == 'new-file'
      newFileTemplate = requireTemplate('new_file.html')
      context.main = compile newFileTemplate, {title}
    else if query.action == 'new-dir'
      newDirTemplate = requireTemplate('new_dir.html')
      context.main = compile newDirTemplate, {title}
    else

      if selectedFile?
        if query.action == 'edit'
          file = requireFile(selectedFile)
          filePreview = compileMarkdown(file)
          editTemplate = requireTemplate('edit.html')
          context.main = compile editTemplate, {title, file, filePreview}
        else
          fileContents = requireFile(selectedFile)
          file = compileMarkdown(fileContents)
          showTemplate = requireTemplate('show.html')
          context.main = compile showTemplate, {title, file}
      else
        dirTemplate = requireTemplate('dir.html')
        context.main = compile dirTemplate, {title}


    layout = requireTemplate('layout.html')
    html = compile layout, context
    callback(html)

