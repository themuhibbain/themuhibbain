$ ->
  # Profile page language
  $(".lang .lg").click ->
    lang = if $(this).parents("article").hasClass("profile-en") then "profile-ms" else "profile-en"
    $(".profile-wrapper").removeClass("profile-en profile-ms").addClass(lang)

  setMargin = ->
    footerHeight = $(".footer").outerHeight(true) - 2
    $(".profile-outer").css "margin-bottom": "#{footerHeight}px"

  $(window).resize $.debounce(setMargin, 250)
  setMargin()
