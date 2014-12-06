module.exports = (grunt)->

    coffeeify = require 'coffeeify'
    stringify = require 'stringify'

    grunt.initConfig
        browserify: 
            dev: 
                options: 
                    preBundleCB: (b)->
                        b.transform coffeeify
                        b.transform(stringify({extensions: ['.hbs', '.html', '.tpl', '.txt']}))
                expand: true
                flatten: true
                src: ['src/js/main.coffee']
                dest: 'bin/js/'
                ext: '.js'

        less:
            dev: 
                files:
                    'bin/css/style.css': ['src/**/*.less']

        connect: 
            server: 
                options:
                    port: 3000
                    hostname: '*'
                    base: '.'

        clean: 
            bin: ['bin']
            dist: ['dist']

        watch: 
            compile: 
                options: {
                    livereload: true,
                }
                files: [
                    'src/**/*.coffee'
                    'src/**/*.less'
                    'src/**/*.html'
                    'fixtures/**/*.html'

                ]
                tasks: ['clean', 'browserify', 'less', 'copy:dev']

        uglify: 
            build:
                files: [{
                    expand: true
                    cwd: "bin/js/"
                    src: ["**/*.js"]
                    dest: "dist/js"
                    ext: ".min.js"
                }]


        cssmin:    
            build:
                files:
                    'dist/css/css/style.min.css': ['bin/css/style.css']

        copy: 
            assets:
                expand: true
                cwd: 'assets'
                src: ['**/*.jpg', '**/*.png', '**/*.gif']
                dest: 'dist/assets'

            lib: 
                expand: true
                cwd: 'lib'
                src: ['**/*.js']
                dest: 'dist/lib'

            dev: 
                files:
                    'index.html': ['fixtures/index.html']

            build:
                files:
                    'dist/index.html': ['fixtures/index-dist.html']


    grunt.loadNpmTasks 'grunt-browserify'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-less'
    grunt.loadNpmTasks "grunt-contrib-copy"
    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-contrib-uglify'

    grunt.registerTask 'default', ->
        grunt.task.run [
            'connect'
            'clean:bin'
            'browserify'
            'less'
            'copy:assets'
            'copy:lib'
            'copy:dev'
            'watch'
        ]

    grunt.registerTask 'build', ->
        grunt.task.run [
            'clean'
            'less'
            'browserify'
            'uglify'
            'cssmin'
            'copy:assets'
            'copy:lib'
            'copy:build'
        ]