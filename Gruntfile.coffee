module.exports = (grunt) ->
  grunt.initConfig
    bowerDirectory: require('bower').config.directory
    less:
      compile:
        options:
          compress: false
          paths: ['less', 'tmp', '<%= bowerDirectory %>/bootstrap/less']
        files:
          'dist/css/ScholarlyMarkdown-BS3.css': ['less/theme.less']
          'dist/css/ScholarlyMarkdown-core.css': ['less/Scholarly-core.less']
    recess:
      dist:
        options:
          compile: true
        files:
          'dist/css/ScholarlyMarkdown-BS3.css': ['dist/css/ScholarlyMarkdown-BS3.css']
          'dist/css/ScholarlyMarkdown-core.css': ['dist/css/ScholarlyMarkdown-core.css']
    watch:
      less:
        files: ['less/*.less','index.html','examples/*.html']
        tasks: ['copy', 'less:compile', 'cssmin:minify', 'copy', 'clean']
        options:
          livereload: true
      # cssmin:
      #   files: ['dist/css/bootstrap.css']
      #   tasks: ['cssmin:minify', 'copy']
      assemble:
        files: ['pages/*.html', 'pages/examples/*', 'README.md']
        tasks: ['assemble']
    cssmin:
      minify:
        expand: true
        cwd: 'dist/css'
        src: ['*.css', '!*.min.css']
        dest: 'dist/css'
        ext: '.min.css'
    connect:
      serve:
        options:
          port: grunt.option('port') || '8000'
          hostname: grunt.option('host') || 'localhost'
    assemble:
      pages:
        options:
          data: './bower.json',
          flatten: true,
          assets: 'dist'
        files:
          'index.html': ['pages/index.html'],
          'examples/': ['pages/examples/*.html']
    copy:
      bootstrap:
        files: [
          { expand: true, cwd: '<%= bowerDirectory %>/bootstrap/less', src: ['bootstrap.less'], dest: 'tmp/' },
          { expand: true, cwd: '<%= bowerDirectory %>/bootstrap/fonts', src: ['*'], dest: 'dist/css/fonts/' }
        ]
      fonts:
        files: [
          { expand: true, cwd: 'fonts', src: ['*'], dest: 'dist/css/fonts/'}
        ]
      copyToSite:
        files: [
          { expand: true, cwd: 'dist/css', src: ['ScholarlyMarkdown-BS3.min.css'], dest: '../../eVITAERC.github.io/css/'},
        ]
    clean: ['tmp']

  grunt.loadNpmTasks('grunt-contrib-less')
  grunt.loadNpmTasks('grunt-recess')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-text-replace')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('assemble')

  grunt.registerTask('default', ['copy', 'less', 'recess', 'cssmin', 'assemble', 'copy', 'clean'])
  grunt.registerTask('serve', ['connect', 'watch'])
