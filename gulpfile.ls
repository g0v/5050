require! <[fs gulp main-bower-files gulp-concat gulp-filter gulp-jade
gulp-livereload gulp-livescript gulp-minify-css gulp-print gulp-rename
gulp-stylus gulp-uglify gulp-util streamqueue tiny-lr]>
require! \fs

port = parseInt fs.readFileSync \port
production = false

tiny-lr-port = 35729

paths =
  app: \app/
  build: \dev/
  production: \production/

tiny-lr-server = tiny-lr!
livereload = if production then gulp-util.noop! else -> gulp-livereload tiny-lr-server

gulp.task \css ->
  css-bower = gulp.src main-bower-files! .pipe gulp-filter \*.css
  styl-app = gulp.src paths.app+\/*.styl .pipe gulp-stylus use: <[nib]>
  streamqueue {+objectMode}
    .done css-bower, styl-app
    .pipe gulp-concat \app.css
    .pipe if production then gulp-minify-css keep-special-comments: 0 else gulp-util.noop!
    .pipe gulp.dest paths.build+\css
    .pipe livereload!
  gulp.src paths.app+\/*/*.styl .pipe gulp-stylus!
    .pipe if production then gulp-minify-css keep-special-comments: 0 else gulp-util.noop!
    .pipe gulp.dest paths.build+\css
    .pipe livereload!

gulp.task \html ->
  html = gulp.src paths.app+\/**/*.html
  jade = gulp.src paths.app+\/**/*.jade .pipe gulp-jade {+pretty}
  streamqueue {+objectMode}
    .done html, jade
    .pipe gulp.dest paths.build
    .pipe livereload!

gulp.task \js ->
  js-bower = gulp.src main-bower-files! .pipe gulp-filter \*.js
  ls-app = gulp.src paths.app+\**/*.ls .pipe gulp-livescript {+bare}
  streamqueue {+objectMode}
    .done js-bower, ls-app
    .pipe gulp-concat \app.js
    .pipe if production then gulp-uglify! else gulp-util.noop!
    .pipe gulp.dest paths.build
    .pipe livereload!

gulp.task \res ->
  gulp.src main-bower-files!, { base: \./bower_components } .pipe gulp-filter \**/fonts/*
    .pipe gulp-rename -> it.dirname = ''
    .pipe gulp.dest paths.build+\/fonts
  gulp.src paths.app+\res/**
    .pipe gulp.dest paths.build+\/res

gulp.task \server ->
  require! \express
  express-server = express!
  express-server.use require(\connect-livereload)!
  express-server.use express.static paths.build
  express-server.listen port
  gulp-util.log "Listening on port: #port"

gulp.task \watch <[build server]> !->
  tiny-lr-server.listen tiny-lr-port, ->
    return gulp-util.log it if it
  gulp.watch [paths.app+\**/*.styl], <[css]>
  gulp.watch [paths.app+\**/*.jade], <[html]>
  gulp.watch [paths.app+\**/*.ls], <[js]>
  gulp.watch [paths.app+\res/**], <[res]>

gulp.task \build <[css html js res]>
gulp.task \default <[watch]>
gulp.task \production ->
  paths.build := paths.production
  production := true
  gulp.start.apply gulp, [\build]

# vi:et:ft=ls:nowrap:sw=2:ts=2
