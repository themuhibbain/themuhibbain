$ ->
  # FastClick
  FastClick.attach document.body

  # Instagram
  $.ajax
    dataType: "jsonp"
    url: "https://api.instagram.com/v1/users/470161390/media/recent"
    data:
      client_id: '18cab2f355964a2fa6238096fc94483b'
      count: 6
    success: (response) ->
      html = []
      $.each response.data, (i, data) ->
        html.push """
        <figure>
          <img src="#{data.images.low_resolution.url}" alt="" data-filter='#{data.filter}'>
          <figcaption>
            <a href="#{data.link}" target="_blank">View on Instagram</a>
          </figcaption>
        </figure>
        """

      $('.instagram').append html.join("")
