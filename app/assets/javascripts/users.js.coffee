$(document).on 'click', '#draft-player', (event) ->
  $.ajax '/users/' + $(this).data('user'),
    type: 'PATCH'
    data: { user: { team_id: $(this).data('team') } }