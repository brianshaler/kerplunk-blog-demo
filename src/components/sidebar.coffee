_ = require 'lodash'
React = require 'react'
moment = require 'moment'

{DOM} = React

module.exports = React.createFactory React.createClass
  getInitialState: ->
    posts = if @props.posts?.length > 0
      @props.posts
    # else if @props.post?.type == 'post'
    #   [@props.post]
    else
      []

    pages = if @props.pages?.length > 0
      @props.pages
    # else if @props.post?.type == 'page'
    #   [@props.post]
    else
      []

    # console.log 'initial sort', @props.currentUrl, _.pluck posts, 'title'

    posts: @sortPosts posts
    pages: @sortPosts pages
    # keys: ['posts', 'pages']
    keys: ['posts']

  componentDidMount: ->
    try
      storedPosts = JSON.parse localStorage.getItem 'blogposts'
    catch ex
      'nevermind'
    posts = @state.posts ? []
    if posts?.length > 0
      posts = if storedPosts?.length > 0
        _.uniq posts.concat(storedPosts), '_id'
      else
        posts
      try
        localStorage.setItem 'blogposts', JSON.stringify posts
      catch ex
        'welp, i tried'
        return
    else
      if posts?.length == 0 and storedPosts?.length > 0
        @setState
          posts: @sortPosts storedPosts
      url = "#{@props.blogSettings.baseUrl}.json"
      @props.request.get url, {}, (err, data) =>
        posts = data?.state?.posts
        return unless posts?.length > 0
        localStorage.setItem 'blogposts', JSON.stringify posts
        return unless @isMounted()
        try
          localStorage.setItem 'blogposts', JSON.stringify posts
        catch ex
          'welp, i tried'
          return
        @setState
          posts: @sortPosts posts
      return
    try
      posts = JSON.parse localStorage.getItem 'blogposts'
    catch ex
      'nevermind'
      return
    @setState
      posts: @sortPosts posts

  componentWillReceiveProps: (newProps) ->
    return if @props.currentUrl == newProps.currentUrl
    @setState
      posts: @sortPosts @state.posts, newProps.currentUrl
    # console.log 'sidebar.componentWillReceiveProps',

  sortPosts: (posts, url = @props.currentUrl) ->
    # posts = _.sortByOrder posts, (post) ->
    #   publishedAt = JSON.stringify post.publishedAt
    #   [
    #     (if post.permalink == url then 1 else 0)
    #     publishedAt
    #     post.title
    #   ]
    # , ['desc', 'desc']
    # console.log 'posts', posts, _.pluck posts, 'publishedAt'
    posts = _.map posts, (post) ->
      post.content = if post.type == 'post'
        DOM.span null,
          DOM.span
            className: 'title'
          ,
            post.title
            if post.status == 0
              DOM.em null, " (draft)"
            else
              null
          DOM.span
            className: 'meta'
          , moment.utc(post.publishedAt).format 'YYYY-MM-DD'
      else
        DOM.span
          className: 'title'
        , post.title
      post
    posts

  sidebarClick: (post) ->
    (e) =>
      @props.hideSidebar()
      unless post._id
        return @props.pushState e
      @props.pushState e, null,
        state:
          post: post
          blogSettings: @props.blogSettings
          theme: @props.theme
          title: post.title
          layout: @props.layout
        component: 'kerplunk-blog-demo:showPost'

  render: ->
    keys = _.sortBy @state.keys, (key, index) =>
      return index unless @state[key]?.length > 0
      mx = _.max _.map (@state[key] ? []), (item, index) =>
        if item.permalink == @props.currentUrl then -1 else 0
      # console.log 'key', key, mx
      mx

    DOM.div
      className: 'blog-sidebar'
    ,
      _.map keys, (key) =>
        return null unless @state[key]
        DOM.div
          key: key
          className: 'sidebar-group'
        ,
          DOM.header null,
            DOM.span null, key
          DOM.ul null,
            _.map (@state[key] ? []), (item, index) =>
              # console.log 'item', item.permalink, 'vs', @props.currentUrl
              DOM.li
                key: item._id ? index
                className: ('highlighted' if item.permalink == @props.currentUrl)
              ,
                DOM.a
                  href: item.permalink
                  onClick: @sidebarClick item
                ,
                  item.content
