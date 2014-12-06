BrickController = require './brick-controller.coffee'
localScore = require './local-score.coffee'

class Game 
    constructor: ->
        @isStart = false

    start: ->
        if not @isStart
            @isStart = true
            @_initScreenSize()
            @_initController()
            @_initBricks()
            @_onUserTap()
        else 
            @restart()

    restart: ->
        @brickController.restart()
        that = @
        that._initBricks()

    end: ->
        localScore.set @brickController.score
        @pages.showEnd @brickController.score

    next: =>
        @brickController.addNewRow()
        that = @
        setTimeout ->
            that.brickController.rowsUp()
            that.brickController.getAndShowNextRow()
        , 10
        setTimeout ->
            if not that.brickController.checkIsEnd()
                that.brickController.checkThreeNear()
            else 
                that.end()
        , 300

    _initScreenSize: ->
        @height = document.documentElement.clientHeight
        @width = document.documentElement.clientWidth

    _initController: ->
        @brickController = new BrickController @

    _initBricks: ->
        @brickController.getAndShowNextRow()
        @addNew()
        @brickController.getAndShowNextRow()
        @addNew()
        @brickController.getAndShowNextRow()
        @addNew()
        @brickController.getAndShowNextRow()
        @addNew()
        @brickController.getAndShowNextRow()
        @addNew()
        @brickController.getAndShowNextRow()

    _onUserTap: ->
        @brickController.onTap()

    addNew: ->
        @brickController.addNewRow()
        @brickController.rowsUp()

module.exports = Game




