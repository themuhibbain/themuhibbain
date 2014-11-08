$ ->
  # Profile page language
  $(".lang-btn-en").click ->
    $(".profile-outer").attr("lang", "en")
  $(".lang-btn-ms").click ->
    $(".profile-outer").attr("lang", "ms")

  $("article h1, article h2, article p").widowFix()
