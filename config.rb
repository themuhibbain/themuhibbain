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
config[:css_dir] = 'assets/css'
config[:js_dir] = 'assets/js'
config[:images_dir] = 'assets/img'
config[:partials_dir] = 'partials'
config[:build_dir] = '../themuhibbain.github.io'

config[:trailing_slash] = false

# Page options, layouts, aliases and proxies
# ----------------------------------------------
# Proxies
proxy '/README.md', '/README.txt', :layout => false
# Ignores
ignore '/README.md'
ignore /^.*\.psd/

# not using layout at all
# config[:layout] = false

# Development-specific configuration
# ----------------------------------------------
configure :development do
  activate :directory_indexes
  # activate :minify_html
  # activate :asset_hash
  # activate :cache_buster
  # activate :minify_css
  config[:debug_assets] = true
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
  activate :asset_hash, :exts => %w(.css .js)

  # Enable cache buster
  activate :cache_buster

  # Or use a different image path
  # config[:http_prefix] = "/Content/images/"

  # Compress PNGs after build (First: gem install middleman-smusher)
  # require "middleman-smusher"
  # activate :smusher
end

# Helpers
# ----------------------------------------------
helpers do

  def site_title
    if current_page.data.title?
      "#{current_page.data.title} &middot; #{data.site.title }"
    else
      data.site.title
    end
  end

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
