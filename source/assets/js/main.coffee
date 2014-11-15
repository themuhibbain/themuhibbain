#= require "jquery"
#= require "fastclick"
#= require "picturefill"
#= require "jquery-timeago"
#= require "slick-carousel"
#= require "jquery-waypoints"
#= require "_widowfix.js"

# String extension: truncate
String::trunc = (n, useWordBoundary) ->
  tooLong = @length > n
  s_ = (if tooLong then @substr(0, n - 1) else this)
  s_ = (if useWordBoundary and tooLong then s_.substr(0, s_.lastIndexOf(" ")) else s_)
  (if tooLong then s_ + "&hellip;" else s_)

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

  # ====================================
  # MAIN PAGE
  # Instagram

  if $('.instagramfeed').length
    iuid = "470161390"
    icid = "18cab2f355964a2fa6238096fc94483b"
    iact = "470161390.5b9e1e6.9db999fd40e54c4b8966bfb5f7c2b105"
    $.ajax
      dataType: "jsonp"
      url: "https://api.instagram.com/v1/users/470161390/media/recent"
      data:
        client_id: icid
        count: 6

      error: (response) ->

      success: (response) ->
        html = []
        $.each response.data, (i, data) ->
          caption = data.caption.text.replace(/\s+/g, " ").replace(/THE MUHIBBAIN - Update\./g, "").trim()
          # caption = caption.replace(/[@]+[A-Za-z0-9-_]+/g, "") # remove username
          # caption = caption.replace(/[#]+[A-Za-z0-9-_]+/g, "") # remove hashtag
          # caption = caption.trim().replace(/via\s*$/, "")
          caption = "<div class='caption'><div class='caption-inner'>#{caption.trim().trunc(180, true)}</div></div>"

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

        $('.instagramfeed').html html.join("")


  if $(".facebook-count").length
    $.getJSON "https://graph.facebook.com/279680398756012?callback=?", (data) ->
      $(".facebook-count").html "#{data.likes} <em>likes</em>"

  if $(".instagram-count").length
    $.getJSON "https://api.instagram.com/v1/users/#{iuid}/?access_token=#{iact}&callback=?", (data) ->
      $(".instagram-count").html "#{data.data.counts.followed_by} <em>followers</em>"

  if $(".youtube-count").length
    $.getJSON "http://gdata.youtube.com/feeds/api/users/TheMuhibbains?alt=json&callback=?", (data) ->
      $(".youtube-count").html "#{data.entry.yt$statistics.subscriberCount} <em>subscribers</em>"

  # $.ajax
  #   type: "GET"
  #   dataType: "jsonp"
  #   url: "https://api.instagram.com/v1/users/470161390"
  #   success: (data) ->
  #     ig_count = data.data.counts.followed_by.toString()
  #     ig_count = add_commas(ig_count)
  #     $(".instagram_count").html ig_count
  #     return

  # Quotes
  $('.quotes-content').slick
    dots: true
    infinite: true
    autoplay: true
    autoplaySpeed: 10000
    arrows: false

  # InstaQuotes
  $('.instaquote-content').slick
    dots: true
    infinite: true
    autoplay: true
    autoplaySpeed: 5000
    arrows: false
    speed: 1000


  # ====================================
  # PROFILE PAGE
  # Top Logo
  $('.profile-middle').waypoint ($dir) ->
    $('.toplogo')[if $dir is 'down' then 'addClass' else 'removeClass']('visible')

  # Profile page language
  $(".lang-btn-en").click ->
    $(".profile-outer").attr("lang", "en")
  $(".lang-btn-ms").click ->
    $(".profile-outer").attr("lang", "ms")

  $("article h1, article h2, article p, blockquote p").widowFix()


  $("a[href*=#]:not([href=#])").click ->
    if location.pathname.replace(/^\//, "") is @pathname.replace(/^\//, "") and location.hostname is @hostname
      target = $(@hash)
      target = (if target.length then target else $("[name=" + @hash.slice(1) + "]"))
      if target.length
        $("html,body").animate
          scrollTop: target.offset().top
        , 500
        false
