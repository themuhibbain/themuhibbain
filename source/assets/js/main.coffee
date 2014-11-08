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

$.nowAndResize = (func) ->
  $(window).resize($.debounce(func, 250))
  func()

$.timeago.settings.strings =
  prefixAgo: null
  prefixFromNow: null
  suffixAgo: "ago"
  suffixFromNow: ""
  seconds: "1m"
  minute: "1m"
  minutes: "%dm"
  hour: "1h"
  hours: "%dh"
  day: "1d"
  days: "%dd"
  month: "1mo"
  months: "%dmo"
  year: "1yr"
  years: "%dyr"
  wordSeparator: " "
  numbers: []

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

        date = $.timeago(new Date(parseInt(data.created_time) * 1000).toISOString())

        html.push """
          <figure>
            <img src="#{data.images.standard_resolution.url}" class="thumb" alt="" data-filter='#{data.filter}'>
            <figcaption>
              #{caption}
              <div class="likes"><div class="likes-inner"><b>#{data.likes.count} likes</b> &middot; #{date}</div></div>
              <a href="#{data.link}" target="_blank">View on Instagram</a>
            </figcaption>
          </figure>
          """

      $('.instagram').html html.join("")
