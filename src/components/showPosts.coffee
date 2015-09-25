_ = require 'lodash'
moment = require 'moment'
React = require 'react'

Post = require './showPost'

{DOM} = React

module.exports = React.createFactory React.createClass
  render: ->
    DOM.div
      className: 'blog-entries'
    ,
      _.map @props.posts, (post) =>
        Post _.extend {}, @props,
          key: post._id
          post: post
          truncate: true
