React = require 'react'

{DOM} = React

module.exports = React.createFactory React.createClass
  shouldComponentUpdate: (newProps) ->
    for k, v of newProps
      return true if @props[k] != v
    false

  render: ->
    DOM.header
      className: 'entry-header'
    ,
      if @props.post.attributes?.type
        DOM.a
          className: 'entry-format'
          href: @props.postTypeUrl
          onClick: @props.postClickHandler @props.post
          title: "All #{@props.post.attributes.type} posts"
        ,
          DOM.span
            className: 'screen-reader-text'
          , @props.post.attributes.type
      else
        DOM.span
          className: 'entry-format'
        , ''
      DOM.h1
        className: 'hentry-title'
      ,
        DOM.a
          href: @props.post.permalink
          onClick: @props.pushState
          title: @props.post.title
          rel: 'bookmark'
        , @props.post.title
