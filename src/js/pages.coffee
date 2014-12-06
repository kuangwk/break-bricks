localScore = require './local-score.coffee'
share = require './share.coffee'

class Pages
    constructor: (game)->
        game.pages = @
        @game = game
        @initEvents()
        @$startPage = $('div#start-page')
        @$pausePage = $('div#pause-page')
        @$endPage = $('div#end-page')
        @$sharePage = $('div#share-page')
        @showHomePage()

    initEvents: ->
        that = this
        $('div#start')[0].addEventListener 'touchstart', (event)->
            if localStorage.hasEverPlay
                that.showGamePage()
                that.game.start()
            else 
                that.showHowToPlayPage()
                localStorage.hasEverPlay = true

        $('div#pause')[0].addEventListener 'touchstart', (event)->
            console.log 'pause'
            that.showPause()

        $('div#continue')[0].addEventListener 'touchstart', (event)->
            that.showGamePage()

        $('div#back-to-home')[0].addEventListener 'touchstart', (event)->
            that.showHomePage()
            console.log 'back to home'

        $('div#replay')[0].addEventListener 'touchstart', (event)->
            that.game.restart()
            that.showGamePage()

        $('div#course')[0].addEventListener 'touchstart', (event)->
            that.showHowToPlayPage()

        $('div#end-replay')[0].addEventListener 'touchstart', (event)->
            that.game.restart()
            that.showGamePage()

        $('div#share')[0].addEventListener 'touchstart', (event)->
            that.showShare()

        $('div#end-share')[0].addEventListener 'touchstart', (event)->
            that.showShare()

        $('div#share-page')[0].addEventListener 'touchstart', (event)->
            that.$sharePage.hide()


    showHowToPlayPage: ->
        console.log 'localScore', localScore.hasEverPlay 
        that = @
        $howToPlay1 = $('div#how-to-play1')
        $howToPlay2 = $('div#how-to-play2')
        $howToPlay1.show()
        $howToPlay1[0].addEventListener 'touchstart', (event)->
            $howToPlay2.show()
            $howToPlay1.hide()

        $howToPlay2[0].addEventListener 'touchstart', (event)->
            $howToPlay2.hide()
            that.game.start()
            that.showGamePage()


    showHomePage: ->
        score = localScore.get()
        $('h1#highest-score').text score
        @hideEnd()
        @$startPage.show()
        @$pausePage.hide()

    showGamePage: ->
        @hideEnd()
        @$startPage.hide()
        @$pausePage.hide()

    showPause: ->
        @hideEnd()
        @$startPage.hide()
        @$pausePage.show()

    showEnd: (score)->
        window.endScore = score
        @_setEndPageContent score
        @$endPage.show()
        @$startPage.hide()
        @$pausePage.hide()

    hideEnd: (score)->
        window.endScore = null
        @$endPage.hide()

    showShare: ->
        @$sharePage.show()


    _setEndPageContent: (score)->
        randContent = @_getRankContentByScore score
        $('span#final-score').text score
        $('p#final-rank').text randContent
        

    _getRankContentByScore: (score)->
        score *= 10
        if 0 <= score < 100 
            @_getContentOne 6
        else if 100 <= score < 200 
            @_getContentOne 8
        else if 200 <= score < 300
            @_getContentOne 10
        else if 300 <= score < 400
            @_getContentOne 21
        else if 500 <= score < 600
            @_getContentOne 32
        else if 600 <= score < 700
            @_getContentOne 43
        else if 700 <= score < 800
            @_getContentOne 50
        else if 800 <= score < 900
            @_getContentOne 62 
        else if 900 <= score < 1000
            @_getContentOne 69 
        else if 1000 <= score < 1100
            @_getContentOne 73
        else if 1100 <= score < 1200
            @_getContentOne 79
        else if 1200 <= score < 1400
            @_getContentTwo(1200, 1400, 5000, 10000, score)
        else 
            @_getContentTwo(1400, 1600, 2000, 5000, score)

        
    _getContentOne: (percentage)->
        "击败了全国#{percentage}%的玩家"

    _getContentTwo: (lowScore, highScore, lowRank, highRank, score)->
        rank = parseInt((highRank - lowRank) / (highScore - lowScore) * (score - lowScore) + lowRank)
        "排在全国#{rank}名"





module.exports = Pages

