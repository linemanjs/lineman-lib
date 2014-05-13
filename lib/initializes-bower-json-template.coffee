fs = require('fs')
path = require('path')
findsRoot = require('find-root-package')

module.exports =
  initialize: (dir = process.cwd()) ->
    topDir = findsRoot.findTopPackageJson(dir)
    return unless isInstalledAsDependency(dir, topDir)
    new BowerJson(topDir).ensureExists()

isInstalledAsDependency = (dir, topDir) ->
  topDir? && topDir != dir


class BowerJson

  constructor: (@projectDir) ->
    @file = "config/bower-template.json"

  ensureExists: ->
    return if @exists()
    console.log("Writing a default '#{@file}' file into '#{@projectDir}'")
    fs.writeFileSync(path.join(@projectDir, @file), @contents)

  exists: ->
    fs.existsSync(path.join(@projectDir, @file))

  contents: """
            {
              "name": "<%= pkg.name %>",
              "version": "<%= pkg.version %>",
              "main": "<%= files.js.uncompressedDist %>",
              "ignore": [
                "app",
                "config",
                "spec",
                "spec-e2e",
                "tasks",
                ".travis.yml",
                "Gruntfile.js",
                "main.js",
                "package.json"
              ],
              "dependencies": {
              },
              "devDependencies": {
              }
            }
            """
