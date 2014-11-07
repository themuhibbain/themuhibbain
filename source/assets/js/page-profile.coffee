$ ->
  # Profile page language
  $(".lang .lg").click ->
    lang = if $(this).parents("article").hasClass("profile-en") then "profile-ms" else "profile-en"
    $(".profile-wrapper").removeClass("profile-en profile-ms").addClass(lang)
