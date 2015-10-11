gulp = require 'gulp'
glut = require 'glut'

coffee = require 'gulp-coffee'
stylus = require 'gulp-stylus'
coffeeAmdify = require 'glut-coffee-amdify'

glut gulp,
  tasks:
    coffee:
      runner: coffee
      src: 'src/**/*.coffee'
      dest: 'lib'
    components:
      runner: coffeeAmdify
      src: 'src/components/**/*.coffee'
      dest: 'public/components'
    stylus:
      runner: stylus
      cache: false
      src: 'src/public/css/demo.styl'
      watch: 'src/public/css/**/*.styl'
      dest: 'public/css'
