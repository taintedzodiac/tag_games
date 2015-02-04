# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '#set-time-slot', (event) ->
  $.ajax '/games/' + $(this).data('game'),
    type: 'PATCH'
    data: { game: { time_slot_id: $('#time_slot').val() } }

$(document).ready ->
  $(".cloudinary-fileupload").bind "cloudinarydone", (e, data) ->
    $(".preview").html $.cloudinary.image(data.result.public_id,
      format: data.result.format
      version: data.result.version
      crop: "fill"
      width: 150
      height: 100
    )
    $('input[name="image_id"]').val data.result.public_id
    true
