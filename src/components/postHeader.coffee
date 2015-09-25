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
      if @props.postType
        DOM.a
          className: 'entry-format'
          href: @props.postTypeUrl
          onClick: @props.pushState
          title: "All #{@props.postType} posts"
        ,
          DOM.span
            className: 'screen-reader-text'
          , @props.postType
      else
        DOM.span
          className: 'entry-format'
        , ''
      DOM.h1
        className: 'hentry-title'
      ,
        DOM.a
          href: @props.permalink
          onClick: @props.pushState
          title: @props.title
          rel: 'bookmark'
        , @props.title
