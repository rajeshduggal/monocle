$           = jQuery
Controller  = require('controller')
State       = require('app/state')

class Landing extends Controller
  className: 'posts-landing'

  constructor: (website_name) ->
    super
    State.set(website_name: website_name)
    @render()

  render: =>
    @website_name = State.get('website_name')
    @html(@view('posts/landing')(this))

module.exports = Landing
