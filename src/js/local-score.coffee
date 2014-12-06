class LocalScore
    constructor: ->
        if not localStorage.score
            localStorage.score = 0

    set: (score)->
        if localStorage.score 
            if localStorage.score < score
                localStorage.score = score  
        else 
            localStorage.score = score

    get: ->
        localStorage.score

module.exports = new LocalScore