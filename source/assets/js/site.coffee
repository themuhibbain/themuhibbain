String::trunc = (n, useWordBoundary) ->
  toLong = @length > n
  s_ = (if toLong then @substr(0, n - 1) else this)
  s_ = (if useWordBoundary and toLong then s_.substr(0, s_.lastIndexOf(" ")) else s_)
  (if toLong then s_ + "&hellip;" else s_)

$ ->
  # FastClick
  FastClick.attach document.body

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


  # Instagram
  $.ajax
    dataType: "jsonp"
    url: "https://api.instagram.com/v1/users/470161390/media/recent"
    data:
      client_id: '18cab2f355964a2fa6238096fc94483b'
      count: 6

    success: (response) ->
      $.each response.data, (i, data) ->
        # match = $.trim(data.caption.text).replace(/\s+/g, " ").match(/THE MUHIBBAIN - Update\.\s+(.*)\s+THE MUHIBBAIN - Update\./)
        # if match
        #   caption = "<div class='caption'><div class='caption-inner'>#{$.trim(match[1]).trunc(200, true)}</div></div>"
        # else
        #   caption = ""

        caption = $.trim(data.caption.text).replace(/\s+/g, " ").replace(/THE MUHIBBAIN - Update\./g, "")
        caption = "<div class='caption'><div class='caption-inner'>#{$.trim(caption).trunc(200, true)}</div></div>"

        $('.instagram').append """
        <figure>
          <img src="#{data.images.low_resolution.url}" class="thumb" alt="" data-filter='#{data.filter}'>
          <figcaption>
            #{caption}
            <div class="likes">#{data.likes.count} likes</div>
            <a href="#{data.link}" target="_blank">View on Instagram</a>
          </figcaption>
        </figure>
        """
