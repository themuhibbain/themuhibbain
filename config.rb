# CSS Autoprefixer
# ----------------------------------------------
activate :autoprefixer do |config|
  config.browsers = ['last 2 versions', 'Explorer >= 9']
  config.inline   = true
end

# Bower Config
# ----------------------------------------------
after_configuration do
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  @bower_assets_path = File.join root, @bower_config['directory']
  sprockets.append_path @bower_assets_path
  sprockets.append_path File.join @bower_assets_path, 'foundation/scss'
end

# Livereload
# Reload the browser automatically whenever files change
# ----------------------------------------------
configure :development do
  activate :livereload, :no_swf => true
end

# Paths
# ----------------------------------------------
set :css_dir, 'assets/css'
set :js_dir, 'assets/js'
set :images_dir, 'assets/img'
set :partials_dir, 'partials'
set :build_dir, '../themuhibbain.github.io'

set :trailing_slash, false

# Page options, layouts, aliases and proxies
# ----------------------------------------------
# Proxies
proxy '/README.md', '/README.txt', :layout => false
# Ignores
ignore '/README.txt'
ignore /^.*\.psd/

# not using layout at all
# set :layout, false

# Development-specific configuration
# ----------------------------------------------
configure :development do
  # activate :minify_html
  # activate :directory_indexes
  # activate :asset_hash
  # activate :cache_buster
  # activate :minify_css
  set :debug_assets, true
end

# Build-specific configuration
# ----------------------------------------------
configure :build do
  # Use relative URLs
  activate :directory_indexes

  # Minify HTML
  # activate :minify_html

  # Optimize images
  # activate :imageoptim

  # Activate gzip
  activate :gzip

  # Minify CSS on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Add asset fingerprinting to avoid cache issues
  # activate :asset_hash

  # Enable cache buster
  activate :cache_buster

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

  # Compress PNGs after build (First: gem install middleman-smusher)
  # require "middleman-smusher"
  # activate :smusher
end

# Helpers
# ----------------------------------------------
helpers do

  def imgurl(url = '')
    url.gsub!(/^\/|\/$/, '')
    "/assets/img/#{url}"
  end

  def list_gallery_thumbs
    require "ostruct"

    images = Array.new
    Dir.glob("#{root}/source/assets/img/gth/*.{jpg,jpeg}").collect do |path|
      img = OpenStruct.new
      size = FastImage.size path
      img.landscape = size[0] > size[1]
      img.url = path.sub "#{root}/source", ""
      images.push img
    end

    images
  end

end
