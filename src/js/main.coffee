Game = require './game.coffee'
Pages = require './pages.coffee'

game = new Game

pages = new Pages game

# for test
window.game = game
window.pages = pages

