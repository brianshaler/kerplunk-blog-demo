_ = require 'lodash'
React = require 'react'

Header = require './header'
Sidebar = require './sidebar'

{DOM} = React

module.exports = React.createFactory React.createClass
  getInitialState: ->
    showSidebar: false

  hideSidebar: ->
    @setState
      showSidebar: false

  buildUrl: (relPath) ->
    if @props.blogSettings.baseUrl == '/'
      relPath
    else
      @props.blogSettings.baseUrl + relPath

  toggleSidebar: (e) ->
    e?.preventDefault?()
    @setState
      showSidebar: !@state.showSidebar

  render: ->
    ContentComponent = @props.getComponent @props.contentComponent

    DOM.div
      className: 'container blog'
    ,
      if @props.globals.public.preContent
        _.map @props.globals.public.preContent, (componentPath, name) =>
          Component = @props.getComponent componentPath
          Component _.extend {}, @props,
            key: name
      else
        null
      # DOM.link
      #   rel: 'stylesheet'
      #   href: '/plugins/kerplunk-blog-demo/css/normalize.css'
      # DOM.link
      #   rel: 'stylesheet'
      #   href: '/plugins/kerplunk-blog-demo/css/skeleton.css'
      DOM.link
        rel: 'stylesheet'
        href: '/plugins/kerplunk-bootstrap/css/bootstrap.css'
      DOM.link
        rel: 'stylesheet'
        href: '/plugins/kerplunk-blog-demo/css/demo.css'
      Header _.extend {}, @props,
        toggleSidebar: @toggleSidebar
        hideSidebar: @hideSidebar
        showSidebar: @state.showSidebar
      DOM.div
        className: "blog-body row #{if @state.showSidebar then 'show' else 'hide'}-sidebar"
      ,
        DOM.div
          className: 'col-md-4 col-lg-3'
        ,
          Sidebar _.extend {}, @props,
            posts: @props.posts
            hideSidebar: @hideSidebar
        DOM.div
          className: 'blog-content col-md-8 col-lg-9'
        ,
          ContentComponent _.extend {}, @props,
            key: @props.currentUrl
            buildUrl: @buildUrl

module.exports.scripts = [
  '/plugins/kerplunk-blog/browserify/react-markdown.js'
]

# ugh.
module.exports
