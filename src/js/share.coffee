class Share 
    constructor: ->
        @data = 
            img_url: "http://kuangwk.github.io/bb20/assets/images/icon.png"
            img_width: "120"
            img_height: "120"
            link: 'http://kuangwk.github.io/bb21/'
            desc: "我是简单暴力之王，瞬间击碎了#{score}块彩砖，不服来战！"
            title: "击碎砖块"


    getShareFriendData: ->
        if window.endScore
            score = window.endScore
        else 
            score = localStorage.score
        @data.desc = "我是简单暴力之王，瞬间击碎了#{score}块彩砖，不服来战！"
        @data.title = "击碎砖块" 
        @data

    getShareTimelineData: ->
        if window.endScore
            score = window.endScore
        else 
            score = localStorage.score
        @data.title = "我是简单暴力之王，瞬间击碎了#{score}块彩砖，不服来战！"
        @data.desc = "击碎砖块" 
        @data



share = window.share = new Share

module.exports = share