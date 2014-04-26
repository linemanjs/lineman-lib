path = require('path')
_ = require('underscore')

module.exports = (lineman) ->
  grunt = lineman.grunt
  warnIfDeprecatedLibConfigStillExists(grunt)
  app = lineman.config.application
  userLibConfig = require(path.join(process.cwd(), 'config', 'application'))(lineman)?.plugins?.lib
  libConfig = _(generateBowerJson: true, includeVendorInDistribution: false).extend(userLibConfig)

  bowerTasks = if libConfig.generateBowerJson then "writeBowerJson" else []

  uglifyFiles = _({}).tap (config) ->
    config["<%= files.js.minified %>"] = "<%= files.js.uncompressedDist %>"

  config:
    loadNpmTasks: ["grunt-write-bower-json", "grunt-contrib-concat"]

    meta:
      banner: """
              /* <%= pkg.name %> - <%= pkg.version %>
               * <%= pkg.description %>
               * <%= pkg.homepage %>
               */

              """

    prependTasks:
      dist: app.appendTasks.dist.concat("concat:uncompressedDist")

    appendTasks:
      dist: app.appendTasks.dist.concat(bowerTasks)

    removeTasks:
      common: app.removeTasks.common.concat("less", "handlebars", "jst", "images:dev", "webfonts:dev", "pages:dev")
      dev: app.removeTasks.dev.concat("server")
      dist: app.removeTasks.dist.concat("cssmin", "images:dist", "webfonts:dist", "pages:dist")

    uglify:
      js:
        files: uglifyFiles

    concat:
      uncompressedDist:
        options:
          banner: "<%= meta.banner %>"
        src: _([
          ("<%= files.js.vendor %>" if libConfig.includeVendorInDistribution),
          "<%= files.coffee.generated %>",
          "<%= files.js.app %>"
        ]).compact()
        dest: "<%= files.js.uncompressedDist %>"

  files:
    js:
      minified: "dist/#{grunt.file.readJSON('package.json').name}.min.js"
      uncompressedDist: "dist/#{grunt.file.readJSON('package.json').name}.js"


warnIfDeprecatedLibConfigStillExists = (grunt) ->
  try
    libConfig = require(path.join(process.cwd(), 'config', 'lib'))
    grunt.warn """
      The `config/lib.{json,js,coffee}` file is deprecated in favor
      of a normal lineman configuration property in `config/application.{js,coffee}`.
      You can configure lineman-lib like so:

      #{JSON.stringify({plugins: {lib: libConfig}}, null, '  ')}

      Then delete your `config/lib.{json,js,coffee}` file.

      """
  catch e
    # Excellent, it doesn't exist.
