# String extension: truncate
String::trunc = (n, useWordBoundary) ->
  toLong = @length > n
  s_ = (if toLong then @substr(0, n - 1) else this)
  s_ = (if useWordBoundary and toLong then s_.substr(0, s_.lastIndexOf(" ")) else s_)
  (if toLong then s_ + "&hellip;" else s_)

# String extension: trim
String::trim = ->
  @replace(/^\s+|\s+$/g,"");

# function debouncer
$.debounce = (func, wait, immediate) ->
  ->
    context = this
    args = arguments
    later = ->
      timeout = null
      func.apply context, args  unless immediate

    callNow = immediate and not timeout
    clearTimeout timeout
    timeout = setTimeout(later, wait)
    func.apply context, args  if callNow

$ ->
  # FastClick
  FastClick.attach document.body

  # Instagram
  $.ajax
    dataType: "jsonp"
    url: "https://api.instagram.com/v1/users/470161390/media/recent"
    data:
      client_id: '18cab2f355964a2fa6238096fc94483b'
      count: 9

    error: (response) ->

    success: (response) ->
      html = []
      $.each response.data, (i, data) ->
        caption = data.caption.text.replace(/\s+/g, " ").replace(/THE MUHIBBAIN - Update\./g, "").trim()
        # caption = caption.replace(/[@]+[A-Za-z0-9-_]+/g, "") # remove username
        caption = caption.replace(/[#]+[A-Za-z0-9-_]+/g, "") # remove hashtag
        caption = caption.trim().replace(/via\s*$/, "")
        caption = "<div class='caption'><div class='caption-inner'>#{caption.trim().trunc(200, true)}</div></div>"

        html.push """
          <figure>
            <img src="#{data.images.standard_resolution.url}" class="thumb" alt="" data-filter='#{data.filter}'>
            <figcaption>
              #{caption}
              <div class="likes"><div class="likes-inner">#{data.likes.count} likes</div></div>
              <a href="#{data.link}" target="_blank">View on Instagram</a>
            </figcaption>
          </figure>
          """

      $('.instagram').html html.join("")
      # setTimeout fauxeqheight, 1000

  # # Faux Equal Height
  # fauxeqheight = ->
  #   col1 = $(".wrapper .column-1")
  #   col2 = $(".wrapper .column-2")

  #   $(".wrapper").removeClass("red white").addClass(if col1.height() > col2.height() then "white" else "red")

  # fauxeqheight()
  # $(window).resize $.debounce(fauxeqheight, 250)

  # Replace SVG to inline SVG
  # http://stackoverflow.com/questions/24933430/img-src-svg-changing-the-fill-color
  # $('img[src*=".svg"]').each ->
  #   $img = $(this)
  #   imgID = $img.attr("id")
  #   imgClass = $img.attr("class")
  #   imgURL = $img.attr("src")

  #   $.get imgURL, ((data) ->
  #     # Get the SVG tag, ignore the rest
  #     $svg = $(data).find("svg")

  #     # Add replaced image's ID to the new SVG
  #     $svg = $svg.attr("id", imgID)  if imgID?

  #     # Add replaced image's classes to the new SVG
  #     $svg = $svg.attr("class", imgClass + " replaced-svg")  if imgClass?

  #     # Remove any invalid XML tags as per http://validator.w3.org
  #     $svg = $svg.removeAttr("xmlns:a")

  #     # Replace image with new SVG
  #     $img.replaceWith $svg
  #   ), "xml"
