#= require "jquery"
#= require "fastclick"
#= require "picturefill"
#= require "jquery-timeago"
#= require "slick-carousel"
#= require "jquery-waypoints"
# require "scrollme"
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

nFormatter = (num, digits) ->
  si = [
    {
      value: 1e18
      symbol: 'E'
    }
    {
      value: 1e15
      symbol: 'P'
    }
    {
      value: 1e12
      symbol: 'T'
    }
    {
      value: 1e9
      symbol: 'G'
    }
    {
      value: 1e6
      symbol: 'M'
    }
    {
      value: 1e3
      symbol: 'k'
    }
  ]
  i = undefined
  i = 0
  while i < si.length
    if num >= si[i].value
      return (num / si[i].value).toFixed(digits).replace(/\.?0+$/, '') + si[i].symbol
    i++
  num

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
    $.getJSON 'http://wms-api.herokuapp.com/tm/instagram/feed?callback=?', (response) ->
        html = []
        $.each response.data, (i, data) ->
          return if i > 5

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
    $.getJSON "http://wms-api.herokuapp.com/tm/facebook?callback=?", (data) ->
      $(".facebook-count").html "#{nFormatter(data.likes, 1)}&nbsp;<em>likes</em>"

  if $(".instagram-count").length
    $.getJSON "http://wms-api.herokuapp.com/tm/instagram?callback=?", (data) ->
      $(".instagram-count").html "#{nFormatter(data.data.counts.followed_by, 1)}&nbsp;<em>followers</em>"

  if $(".twitter-count").length
    $.getJSON "http://wms-api.herokuapp.com/tm/twitter?callback=?", (data) ->
      $(".twitter-count").html "#{nFormatter(data.followers_count, 1)}&nbsp;<em>followers</em>"

  if $(".youtube-count").length
    $.getJSON "http://wms-api.herokuapp.com/tm/youtube?callback=?", (data) ->
      $(".youtube-count").html "#{nFormatter(data.items[0].statistics.subscriberCount, 1)}&nbsp;<em>subscribers</em>"

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
    dots: false
    infinite: true
    autoplay: true
    autoplaySpeed: 5000
    arrows: false
    # speed: 1000

  # Promos
  $('.themuhibbain-content').slick
    dots: true
    infinite: true
    autoplay: true
    autoplaySpeed: 10000
    arrows: false
    speed: 1000
    # adaptiveHeight: true


  # ====================================
  # PROFILE PAGE
  # Top Logo
  $('.profile-middle').waypoint ($dir) ->
    $('.toplogo')[if $dir is 'down' then 'addClass' else 'removeClass']('visible')

  # Profile page language
  en_el = $('h1:lang(en), h2:lang(en), h3:lang(en), p:lang(en), button:lang(en)')
  ms_el = $('h1:lang(ms), h2:lang(ms), h3:lang(ms), p:lang(ms), button:lang(ms)')

  $('body.profile').addClass('lang--en')
  $('.lang-btn-en').click ->
    $('body.profile').removeClass('lang--en lang--ms').addClass('lang--en')
  $(".lang-btn-ms").click ->
    $('body.profile').removeClass('lang--en lang--ms').addClass('lang--ms')

  # Widow fix
  $("article p, blockquote p").widowFix()

  # Smooth scroll
  $("a[href*=#]:not([href=#])").click ->
    if location.pathname.replace(/^\//, "") is @pathname.replace(/^\//, "") and location.hostname is @hostname
      target = $(@hash)
      target = (if target.length then target else $("[name=" + @hash.slice(1) + "]"))
      if target.length
        $("html,body").animate
          scrollTop: target.offset().top
        , 500
        false
