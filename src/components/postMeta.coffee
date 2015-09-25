React = require 'react'

{DOM} = React

module.exports = React.createFactory React.createClass
  shouldComponentUpdate: (newProps) ->
    for k, v of newProps
      return true if @props[k] != v
    false

  render: ->
    DOM.footer
      className: 'entry-meta'
    ,
      DOM.span
        className: 'post-date'
      ,
        DOM.a
          href: @props.permalink
          title: @props.createdAt
          rel: 'bookmark'
        ,
          DOM.time
            className: 'entry-date'
            dateTime: @props.createdAt
          ,
            @props.createdAt
      ' '
      DOM.span
        className: 'byline'
      ,
        DOM.span
          className: 'author vcard'
        ,
          DOM.a
            className: 'url fn n'
            href: @props.authorUrl
            title: "View all posts by #{@props.author}"
            rel: 'author'
          , @props.author
      if @props.tags?.length > 0
        DOM.span
          className: 'tags-links'
        , ''
      else
        null
      if @props.isUser
        DOM.span
          className: 'edit-link'
        ,
          DOM.a
            href: "/admin/blog/edit/#{@props.postId}"
          , 'Edit'
      else
        null
