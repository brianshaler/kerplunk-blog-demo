React = require 'react'

{DOM} = React

module.exports = React.createFactory React.createClass
  getInitialState: ->
    fixed: false
    fixedHeaderHeight: 0
    headerHeight: 0
    scrollP: 0
    scrollTop: 0

  buildUrl: (relPath) ->
    if @props.blogSettings.baseUrl == '/'
      relPath
    else
      @props.blogSettings.baseUrl + relPath

  componentDidMount: ->
    window.blogHeader = @
    window.addEventListener 'scroll', @handleScroll
    window.addEventListener 'resize', @handleResize
    # heights = @calculateHeights()
    # @handleScroll null, heights
    @handleScroll()

  componentWillUnmount: ->
    window.removeEventListener 'scroll', @handleScroll
    window.removeEventListener 'resize', @handleResize

  calculateHeights: ->
    heights =
      fixedHeaderHeight: React.findDOMNode(@refs.fixedHeader)?.clientHeight ? 0
      headerHeight: React.findDOMNode(@refs.header)?.clientHeight ? 0
    if heights.fixedHeaderHeight != @state.fixedHeaderHeight or heights.headerHeight != @state.headerHeight
      @setState heights
    heights

  handleScroll: (e) ->
    return unless @isMounted()
    heights = @calculateHeights()
    # console.log 'handlescroll', heights.headerHeight, heights.fixedHeaderHeight
    # return if window.scrollY == 0 and @state.fixed == false
    # return if window.scrollY > heights.headerHeight and @state.fixed == true
    scrollTransitionStart = (heights.headerHeight - heights.fixedHeaderHeight * 2) / 2
    scrollTransitionEnd = heights.headerHeight - heights.fixedHeaderHeight
    scrollP = ((window?.scrollY ? 0) - scrollTransitionStart) / (scrollTransitionEnd - scrollTransitionStart)
    scrollP = 0 unless scrollP > 0
    scrollP = 1 unless scrollP < 1
    @setState
      fixed: window.scrollY > 1
      scrollP: scrollP

  handleResize: ->
    # heights = @calculateHeights()
    # @handleScroll null, heights
    setTimeout =>
      return unless @isMounted()
      @handleScroll()# null, @calculateHeights()
    , 1

  render: ->
    ContentComponent = @props.getComponent @props.contentComponent
    scrollP = @state.scrollP

    DOM.header
      className: "row blog-header #{if @state.fixed then 'not-at-top' else 'at-top'}"
      # style:
      #   height: "#{6 - 2 * scrollP}em"
    ,
      DOM.div
        className: "col-xs-12 header-fixed"
        ref: 'fixedHeader'
        style: if @state.scrollP
          top: -(1 - @state.scrollP) * @state.headerHeight
      ,
        DOM.a
          className: [
            'glyphicon'
            (if @props.showSidebar then 'glyphicon-chevron-up' else 'glyphicon-chevron-down')
            'toggle-sidebar'
            'hidden-md-inline-block'
            'hidden-lg-inline-block'
          ].join ' '
          href: '#'
          onClick: @props.toggleSidebar
          style:
            fontWeight: 'normal'
            fontSize: '1em'
            marginRight: '0.5em'
        , ''
        DOM.h1
          className: 'site-title'
        ,
          DOM.a
            onClick: @props.pushState
            href: @props.blogSettings.baseUrl
            rel: 'home'
            style: {}
          , @props.blogSettings.title
        DOM.h2
          className: 'site-description'
        ,
          DOM.span
            style: {}
          , @props.blogSettings.tagline
        DOM.div
          className: 'clearfix clear'
        , ''
      DOM.div
        className: 'col-xs-12 header-plain hidden-sm hidden-xs'
        ref: 'header'
      ,
        DOM.h1
          className: 'site-title'
        ,
          DOM.a
            onClick: @props.pushState
            href: @props.blogSettings.baseUrl
            rel: 'home'
            style: {}
          , @props.blogSettings.title
        DOM.h2
          className: 'site-description'
        ,
          DOM.span
            style: {}
          , @props.blogSettings.tagline
        DOM.div
          className: 'clearfix clear'
        , ''
