[THREE_COLOR_SAME, TWO_COLOR_SAME, NO_COLOR_SAME] = [0, 1, 2]

class BrickCreator 
    constructor: (brickCtrl)-> 
        @brickCtrl = brickCtrl

    getNew: ->
        score = @brickCtrl.score

        # score *= 10

        if 0 <= score <= 199
            # console.log 'level 1'
            [per1, per2, per3, colorCount] = [30, 60, 10, 4]
        else if 200 <= score <= 399
            # console.log 'level 2'
            [per1, per2, per3, colorCount] = [20, 60, 20, 4]
        else if 400 <= score <= 599
            # console.log 'level 3'
            [per1, per2, per3, colorCount] = [10, 50, 40, 4]
        else if 600 <= score <= 799
            # console.log 'level 4'
            [per1, per2, per3, colorCount] = [0, 30, 70, 5]
        else if 800 <= score <= 999
            # console.log 'level 5'
            [per1, per2, per3, colorCount] = [0, 10, 90, 5]
        else if 1000 <= score <= 1199
            # console.log 'level 6'
            [per1, per2, per3, colorCount] = [0, 0, 100, 5]
        else if 1200 <= score <= 1799
            # console.log 'level 7'
            [per1, per2, per3, colorCount] = [0, 0, 100, 6]
        else if 1800 <= score <= 2399
            # console.log 'level 8'
            [per1, per2, per3, colorCount] = [0, 0, 100, 7]
        else if 2400 <= score <= 2999
            # console.log 'level 8'
            [per1, per2, per3, colorCount] = [0, 0, 100, 8]
        else 
            alert('爆机了')
            [per1, per2, per3, colorCount] = [0, 0, 100, 8]


        type = @_getTypeByProb(per1, per2, per3)
        colors = @_getColorsByType(colorCount, type)
        if @_isValid colors
            return colors
        else 
            return @getNew()

    _getTypeByProb: (per1, per2, per3)->
        randomNum = parseInt( 100 * Math.random() )
        if  0 <= randomNum < per1
            return THREE_COLOR_SAME
        else if per1 <= randomNum <= per2 + per1
            return TWO_COLOR_SAME
        else if (per2 + per1) < randomNum < (per2 + per1 + per3)
            return NO_COLOR_SAME
        else 
            console.log 'error', randomNum

    _getColorsByType: (colorCount, type)->
        switch type
            when THREE_COLOR_SAME
                @_getThreeColorSame colorCount
            when TWO_COLOR_SAME
                @_getTwoColorSame colorCount
            when NO_COLOR_SAME
                @_getNoColorSame colorCount

    _isValid: (colors)->
        for color, i in colors
            if (up1 = @brickCtrl.bc[i][0]) and (up2 = @brickCtrl.bc[i][1])
                if up1.color is up2.color
                    if up1.color is color
                        return false
        true

    _getThreeColorSame: (colorCount)->
        color1 = @_getRandomNum(colorCount)
        color2 = @_getRandomNum(colorCount, [color1])
        threeColorType = @_getRandomNum(2)
        switch threeColorType
            when 0
                return [color1, color1, color2, color1]
            when 1
                return [color1, color2, color1, color1]

    _getTwoColorSame: (colorCount)->
        color1 = @_getRandomNum(colorCount)
        color2 = @_getRandomNum(colorCount, [color1])
        color3 = @_getRandomNum(colorCount, [color1])
        threeColorType = @_getRandomNum(6)
        switch threeColorType
            when 0
                return [color1, color1, color2, color3]
            when 1
                return [color1, color2, color1, color3]
            when 2
                return [color1, color2, color3, color1]
            when 3
                return [color2, color1, color1, color3]
            when 4
                return [color2, color1, color3, color1]
            when 5
                return [color2, color3, color1, color1]

    _getNoColorSame: (colorCount)->
        color1 = @_getRandomNum(colorCount)
        color2 = @_getRandomNum(colorCount, [color1])
        color3 = @_getRandomNum(colorCount, [color1, color2])
        color4 = @_getRandomNum(colorCount, [color1, color2, color3])
        [color1, color2, color3, color4]

    _getRandomNum: (count, excepts=[])->
        result = parseInt(Math.random() * count)
        if excepts.indexOf(result) is -1
            return result
        else 
            return @_getRandomNum count, excepts


module.exports = BrickCreator