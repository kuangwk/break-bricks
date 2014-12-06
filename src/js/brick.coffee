HEIGHT = document.documentElement.clientHeight
WIDTH = document.documentElement.clientWidth

BRICK_SIZE = parseInt (HEIGHT / 10.5)

COLORS = [
    "#fff",
    "#3077bd",
    "#ff6699",
    "#993399",
    "#cc66cc",
    "#99ccff",
    "#ffcccc"
    "#000"
]


class Brick
    constructor: (color, position, $wrapper, num, size, isSmall)->
        @num = num
        @$wrapper = $wrapper
        @color = color
        @position = position
        @$dom = @_createDom size, isSmall
        @_appendToParent() 
        @isSmall = isSmall

    up: (count=1)->
        bottom = @position.y 
        bottom += count 
        @move bottom

    down: (count=1)->
        bottom = @position.y     
        bottom -= count 
        @move bottom

    move: (bottom)->
        @position.y = bottom
        x = @position.x * BRICK_SIZE
        y = - @position.y * BRICK_SIZE
        @$dom.attr 'data-y', bottom
        @$dom.css "-webkit-transform", "translate3d(#{x}px, #{y}px, 0)"

    remove: (middle)->
        if @isSmall 
            @$dom.remove()
        else 
            isRight =  @position.x >= middle
            @$dom.addClass('brick-remove')
            @_removeAnimation @$dom, isRight
            setTimeout =>
                @$dom.remove()
            , 2000


    _removeAnimation: ($dom, isRight)->
        if isRight
            x = @position.x * BRICK_SIZE + 15
            degree = -20 
            degree2 = -90
        else 
            x = @position.x * BRICK_SIZE - 15
            degree = 20 
            degree2 = 90

        y = ( - @position.y * BRICK_SIZE )  - 10
        @$dom.css "z-index", "10000000000"
        @$dom.css "-webkit-transform", "translate3d(#{x}px, #{y}px, 0) rotate(#{degree}deg)"
        @$dom.css '-webkit-transition', 'all 0.2s ease-out'
        that = @
        setTimeout ->
            that.$dom.css '-webkit-transition', 'all 0.4s ease-in'
            that.$dom.css "-webkit-transform", "translate3d(#{x}px, 100px, 0) rotate(#{degree2}deg)"
        , 200



    _createDom: (size, isSmall)->
        brick_size = size || BRICK_SIZE

        $dom = $("<div class='brick'></div>")
        $dom.css
            backgroundColor: COLORS[@color]
            width: brick_size
            height: brick_size
            zIndex: @num
        x = @position.x * brick_size
        y = - @position.y * brick_size

        $dom.css "-webkit-transform", "translate3d(#{x}px, #{y}px, 0)"
        $dom.attr 'data-x', @position.x 
        $dom.attr 'data-y', @position.y
        if isSmall 
            $dom.addClass 'small'
        $dom

    _appendToParent: ->
        @$wrapper.append @$dom


module.exports = Brick