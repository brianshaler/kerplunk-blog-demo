_ = require 'lodash'
moment = require 'moment'
React = require 'react'
ReactMarkdownName = 'react-markdown'

PostHeader = require './postHeader'
PostMeta = require './postMeta'

ReactMarkdownClass = ReactMarkdown ? require ReactMarkdownName
ReactMarkdownComponent = React.createFactory ReactMarkdownClass

{DOM} = React

module.exports = React.createFactory React.createClass
  getInitialState: ->
    truncatedBody = body = @props.post.body

    if @props.truncate
      maxLines = 12
      lines = body.split '\n'
      usedLines = []
      count = 0
      for line in lines
        break if count >= maxLines
        usedLines.push line
        count += 1 + Math.floor line.length / 50
      truncatedBody = usedLines.join '\n'

    truncate: truncatedBody.length != body.length
    truncatedBody: truncatedBody
    body: body
    postComponents: @postComponents body

  onExpand: (e) ->
    e.preventDefault()
    @setState
      truncate: false

  postComponents: (body) ->
    lines = _.map body.split('\n'), (line) ->
      return line unless /^\{.+\}$/.test line
      try
        obj = JSON.parse line
      catch err
        'nothing'
      return line unless obj?.componentPath?.length > 0

      path: obj.componentPath
      data: obj.data

    components = []
    for line in lines
      if typeof line is 'string'
        if components.length > 0 and typeof components[components.length-1] is 'string'
          components[components.length-1] += "#{line}\n"
        else
          components.push "#{line}\n"
      else
        components.push line
    components

  render: ->

    CustomComponent = if @props.post.attributes?.componentPath?.length > 0
      # console.log 'get component', @props.post.attributes.componentPath
      @props.getComponent @props.post.attributes.componentPath
    else
      false
    postClass = if /<img/.test @props.post.body
      'format-image'
    else
      'format-post'

    DOM.article
      id: "post-#{@props.post._id}"
      className: "hentry #{postClass}"
    ,
      PostHeader
        postTypeUrl: @props.buildUrl "/posts/type/#{@props.postType}"
        postType: @props.post.attributes?.type
        permalink: @props.post.permalink
        title: @props.post.title
        pushState: @props.pushState

      # CONTENT
      DOM.div
        className: 'entry-content'
      ,
        _.map @state.postComponents, (component, index) =>
          if typeof component is 'string'
            ReactMarkdownComponent
              key: index
              source: if @state.postComponents.length == 1 and typeof @state.postComponents[0] is 'string' and @state.truncate
                @state.truncatedBody
              else
                component
              escapeHtml: true
          else
            Component = @props.getComponent component.path
            DOM.div
              key: index
              className: 'clear clearfix'
            ,
              Component _.extend {}, @props, component.data,
                key: index

        if @state.postComponents.length == 1 and typeof @state.postComponents[0] is 'string' and @state.truncate
          DOM.p
            className: 'entry-meta continue-reading'
          ,
            DOM.a
              href: @props.post.permalink
              onClick: @onExpand
            , 'Continue reading'
        else
          null

        PostMeta
          author: @props.post.author
          authorUrl: @props.buildUrl "/posts/author/#{@props.post.author}"
          createdAt: moment.utc(@props.post.createdAt).format('llll')
          isUser: @props.isUser
          permalink: @props.post.permalink
          postId: @props.post._id
          tags: @props.post.tags

        # DOM.div
        #   className: 'page-links'
        #   style:
        #     display: 'none'
        # ,
        #   DOM.span
        #     className: 'active-link'
        #   , '<- previous'
        #   DOM.span
        #     className: 'active-link'
        #   , 'next ->'
      if @props.previousPost or @props.nextPost
        DOM.nav
          className: 'navigation post-navigation'
          role: 'navigation'
        ,
          DOM.h1
            className: 'screen-reader-text'
          , 'Post navigation'
          DOM.div
            className: 'nav-links'
          ,
            DOM.div
              className: 'nav-previous'
            ,
              DOM.a
                href: @props.previousPost
              ,
                DOM.span
                  className: 'screen-reader-text'
                , 'Previous post'
            DOM.div
              className: 'nav-next'
            ,
              DOM.a
                href: @props.nextPost
              ,
                DOM.span
                  className: 'screen-reader-text'
                , 'Next post'
      else
        null
