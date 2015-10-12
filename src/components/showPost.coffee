_ = require 'lodash'
moment = require 'moment'
React = require 'react'

PostHeader = require './postHeader'
PostMeta = require './postMeta'

{DOM} = React

module.exports = React.createFactory React.createClass
  onExpand: (e) ->
    e.preventDefault()
    @setState
      truncate: false

  render: ->
    RenderPostContent = @props.getComponent 'kerplunk-blog:renderPostContent'

    postClass = if /<img/.test @props.post.body
      'format-image'
    else
      'format-post'

    DOM.article
      id: "post-#{@props.post.permalink.replace '/', '-'}"
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
        RenderPostContent _.extend {}, @props, @state

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
