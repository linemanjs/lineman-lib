path = require('path')
libConfig = require(path.join(process.cwd(), 'config', 'lib'))

module.exports = (lineman) ->
  grunt = lineman.grunt
  _ = grunt.util._
  app = lineman.config.application

  bowerTasks = if libConfig.generateBowerJson then "writeBowerJson" else []

  uglifyFiles = _({}).tap (config) ->
    config["<%= files.js.minified %>"] = "<%= files.js.uncompressedDist %>"

  config:
    loadNpmTasks: ["grunt-write-bower-json", "grunt-contrib-concat"]

    meta:
      banner: """
              /* <%= pkg.name %> - <%= pkg.version %>
               * <%= pkg.description || pkg.description %>
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

