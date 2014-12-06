WIDTH = 4
HEIGHT = 10
WRAPPER_MARGIN_LEFT = 6 

Brick = require './brick.coffee'
BrickCreator = require './brick-creator.coffee'


class BrickController 
    constructor: (game)->
        @game = game
        @bc = @_initBrickCollection()
        @_initWrapper()
        @$score = $('span#score')
        @score = 0
        @brickCreator = new BrickCreator @
        @previousTipsBrick = []

    restart: ->
        @_removeAllBricks()
        @_resetScore()

    addNewRow: ->
        newBrickNums = @nextBrickNums
        for i in [0..3]
            @bc[i][-1] = new Brick newBrickNums[i], {x: i, y: -1}, @$wrapper, i

    rowsUp: ->
        for x in [WIDTH-1..0]
            for y in [HEIGHT..-1]
                if @bc[x][y]
                    @bc[x][y].up()
                    @bc[x][y+1] = @bc[x][y]
                    @bc[x][y] = null

    getAndShowNextRow: ->
        @nextBrickNums = @brickCreator.getNew()
        @_showNextRow @nextBrickNums

    onTap: ->
        that = this
        @$wrapper[0].addEventListener 'touchstart', (event)->
            if (event.target.className) is 'brick'
                brick = event.target
                position  = that._getPositionByDom brick
                toReovedBricks = []
                that._findAndReomveSameColorBricks position, toReovedBricks
                that._calculateFallDown()
                setTimeout ->
                    that._findAndReomveMoreThanThreeNearByBricks that.game.next
                , 300

    checkThreeNear: ->
        @_findAndReomveMoreThanThreeNearByBricks()

    checkIsEnd: ->
        for i in [0..3]
            if @bc[i][10]
                return true
        false

    _resetScore: ->
        @score = 0
        strScore = ('0000' + @score).slice -4
        @$score.text strScore

    _removeAllBricks: ->
        for x in [0..3]
            for y in [0..12]
                if @bc[x][y]
                    @bc[x][y].remove 1.5
                    @bc[x][y] = null

    _showNextRow: (nums)->
        for brick in @previousTipsBrick
            brick.remove()
        for i in [0..3]
            @previousTipsBrick.push (new Brick nums[i], {x: i, y: 0}, @$nextBrickWrapper, i, 20, true)



    _initWrapper: ->
        brickSize = parseInt (window.innerHeight / 10.5)
        @$wrapper = $('div#wrapper')
        @$nextBrickWrapper = $('div#next-bricks-wrapper')
        @wrapperHeight = @game.height 
        @wrapperWidth = brickSize * 4 + 8
        @$wrapper.css 
            height: @wrapperHeight
            width: @wrapperWidth
        $('div#right').css
            width: @game.width - @wrapperWidth - WRAPPER_MARGIN_LEFT
        $('div.end-line').css 'top', brickSize / 4



    _calculateFallDown: ->
        for x in [0..WIDTH-1]
            for y in [0..HEIGHT-1]
                if not @bc[x][y]
                    if firstUpperBrick = @_hasUpperBrick(x, y)
                        upperY = firstUpperBrick.position.y
                        @bc[x][y] = firstUpperBrick
                        @bc[x][upperY] = null
                        firstUpperBrick.down(firstUpperBrick.position.y - y)


    _hasUpperBrick: (currentX, currentY)->
        for y in [currentY+1..HEIGHT-1]
            if @bc[currentX][y]
                return @bc[currentX][y]
        return null

    _removeBricks: (bricks)->
        console.log 'remove'
        positionXs = []
        sum = 0
        for brick in bricks
            positionX = brick.x
            if positionXs.indexOf(positionX) is -1
                positionXs.push positionX
                sum += positionX
        middle = sum / positionXs.length

        for brick in bricks
            @_scoreUp()
            @bc[brick.x][brick.y].remove middle
            @bc[brick.x][brick.y] = null

    _scoreUp: ->
        @score += 1
        strScore = ('0000' + @score).slice -4
        @$score.text strScore

    _findAndReomveMoreThanThreeNearByBricks: (callback)->
        toRemoveBricks = []
        for x in [0..WIDTH-1]
            for y in [0..HEIGHT-1]
                pos = {x, y}
                if brick = @bc[x][y] and not @_isPosInCollection(toRemoveBricks, pos)
                    if @_hasThreeSameColorBricks pos
                        toRemoveBricks.push pos
                        @_findNearBySameColorBricks pos, toRemoveBricks
        if toRemoveBricks.length > 0
            @_removeBricks toRemoveBricks                  
            @_calculateFallDown()
            that = this
            setTimeout ->
                that._findAndReomveMoreThanThreeNearByBricks callback
            , 300
        else 
            callback?()

    _hasThreeSameColorBricks: (pos)->
        x = pos.x
        y = pos.y
        if @_isVaildPosition({x:x, y:y+1}) and @_isVaildPosition({x:x, y:y+2})
            if @_isTheSameColor(@bc[x][y], @bc[x][y+1]) and @_isTheSameColor(@bc[x][y], @bc[x][y+2])
                return true
        if @_isVaildPosition({x:x+1, y:y}) and @_isVaildPosition({x:x+2, y:y}) 
            if @_isTheSameColor(@bc[x][y], @bc[x+1][y]) and @_isTheSameColor(@bc[x][y], @bc[x+2][y])
                return true
        false

    _findAndReomveSameColorBricks: (pos, array)->
        array.push pos
        @_findNearBySameColorBricks pos, array
        @_removeBricks array

    _findNearBySameColorBricks: (pos, array)->
        @_checkIsSameColorAndAdd pos, {x: pos.x - 1, y: pos.y}, array
        @_checkIsSameColorAndAdd pos, {x: pos.x + 1, y: pos.y}, array
        @_checkIsSameColorAndAdd pos, {x: pos.x, y: pos.y - 1}, array
        @_checkIsSameColorAndAdd pos, {x: pos.x, y: pos.y + 1}, array

    _checkIsSameColorAndAdd:  (centerPos, nearPos, array)->
        if @_isVaildPosition(nearPos) and (nearBrick = @bc[nearPos.x][nearPos.y]) and not @_isPosInCollection(array, nearPos)
            currentBrick = @bc[centerPos.x][centerPos.y]
            if currentBrick.color is nearBrick.color
                array.push nearBrick.position
                @_findNearBySameColorBricks nearBrick.position, array

    _isVaildPosition: (pos)->
        0 <= pos.x and pos.x <= WIDTH - 1 and 0 <= pos.y and pos.y <= HEIGHT - 1

    _isTheSameColor: (brick1, brick2)->
        if brick1 and brick2
            return brick1.color is brick2.color
        return false

    _getPositionByDom: (dom)->
        x = parseInt($(dom).attr 'data-x')
        y = parseInt($(dom).attr 'data-y')
        {x, y}

    _isPosInCollection: (collection, pos)->
        for item in collection
            if (item.x is pos.x) and (item.y is pos.y)
                return true
        return false

    _initBrickCollection: ->
        brickCollection = []
        brickCollection[0] = []
        brickCollection[1] = []
        brickCollection[2] = []
        brickCollection[3] = []
        brickCollection


module.exports = BrickController