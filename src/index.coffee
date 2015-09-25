module.exports = (System) ->
  globals:
    public:
      blog:
        themes:
          'kerplunk-blog-demo':
            name: 'kerplunk-blog-demo'
            displayName: 'Demo Theme'
            components:
              post: 'kerplunk-blog-demo:showPost'
              posts: 'kerplunk-blog-demo:showPosts'
              layout: 'kerplunk-blog-demo:layout'
