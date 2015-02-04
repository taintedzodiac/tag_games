# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Handle votes and unvotes for games
$(document).on 'click', '.vote-up', (event) ->
  $.ajax '/votes',
    type: 'POST'
    data: { game: { id: $(this).data('game') } }
    
$(document).on 'click', '.vote-down', (event) ->
  $.ajax '/votes/' + $(this).data('vote'),
    type: 'DELETE'

$(document).ajaxComplete (event, request, settings) ->
  response = $.parseJSON(request.responseText)
  if response.type == 'vote'
    if response.action == 'create'
      if response.success
        game_id = response.game._id.$oid
        
        vote_button = $('#vote-up-' + game_id)
        vote_button.removeClass('vote-up').addClass('vote-down alert').text('Unvote').data('vote', response.vote._id.$oid).attr('id', 'vote-down-' + response.vote._id.$oid)
        
        vote_count_span = $('#vote-count-' + game_id)
        vote_count_span.text(response.total_votes)
    
    else if response.action == 'destroy'
      if response.success
        vote_id = response.vote_id
        game_id = response.game._id.$oid
        
        vote_button = $('#vote-down-' + vote_id)
        vote_button.removeClass('vote-down alert').addClass('vote-up').text("I'll Play It").data('vote', '').attr('id', 'vote-up-' + vote_button.data('game'))
        
        vote_count_span = $('#vote-count-' + game_id)
        vote_count_span.text(response.total_votes)
        
        
        