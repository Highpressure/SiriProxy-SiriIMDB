require 'cora'
require 'siri_objects'
require 'imdb'

#######
# SiriIMDB is a Siri Proxy plugin that allows Siri to give you recommendations, ratings, and other useful information about anything on IMDB.
# Check the readme file for more detailed usage instructions.
# Created by parm289  - you are free to use, modify, and redistribute as you like, as long as you give the original author credit.
######

class SiriProxy::Plugin::SiriIMDB < SiriProxy::Plugin
  def initialize(config)
  end
  
  def getActors(movieName)
	search = Imdb::Search.new(movieName)
	movie = search.movies[0]
	return movie.cast_members
  end
  
  def getLeadActor(movieName)
	search = Imdb::Search.new(movieName)
	movie = search.movies[0]
	movieActor = movie.cast_members.first
	return movieActor
  end
  
  def getRating(movieName)
	search = Imdb::Search.new(movieName)
	movie = search.movies[0]
	movieRating = movie.rating()
	return movieRating
  end

  listen_for /wieviele sterne hat (.*) bekommen/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	#Search for the movie and get the rating as a string
	movieRating = getRating (movieTitle)
	movieRatingString = movieRating.to_s
	say "" + movieTitle + " hat eine Bewertung von " + movieRatingString + " Sternen."
    request_completed
  end
  
  listen_for /wie ist der film (.*)/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieRating = getRating(movieTitle)
	movieRatingString = movieRating.to_s
	if (movieRating < 6)
		say "Du solltest " + movieTitle + " dir nicht antun. Er hat nur " + movieRatingString + " Sterne."
	elsif (movieRating < 8)
		say "Ich kann dir " + movieTitle + " empfehlen! Der Film hat " + movieRatingString + " Sterne."
	elsif (movieRating >= 8)
		say "" + movieTitle + " ist ein Kultfilm! Er hat ganze " + movieRatingString + " Sterne!"
	end
    request_completed
  end

 listen_for /wer hat in (.*) mit gespielt/i  do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieActors = getActors(movieTitle)
	say "" + movieActors[0] + ", " + movieActors[1] + ", und " + movieActors[2] + " haben in " + movieTitle + " mit gespielt."
    request_completed
  end

 listen_for /wer war in (.*) zu sehen/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieActors = getActors(movieTitle)
	say "" + movieActors[0] + ", " + movieActors[1] + ", und " + movieActors[2] + " haben in " + movieTitle + " mit gespielt."
    request_completed
  end  
  
  listen_for /welche schauspieler spielen bei (.*) mit/i  do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieActors = getActors(movieTitle)
	say "" + movieActors[0] + ", " + movieActors[1] + ", und " + movieActors[2] + " haben in " + movieTitle + " mit gespielt."
    request_completed
  end
  
  listen_for /wer war hauptdarsteller in (.*)/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	movieActor = getLeadActor(movieTitle)
	say "Der Hauptdarsteller in " + movieTitle + " ist " + movieActor + "."
	request_completed
  end
  
  listen_for /wer war der regiseur von (.*)/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieDirectors = movie.director()
	say "Der Regiseur von " + movieTitle + " ist " + movieDirectors[0] + "."
	request_completed
  end
  
  listen_for /wann wurde (.*) released/i do |movieTitle|
	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
	search = Imdb::Search.new(movieTitle)
	movie = search.movies[0]
	movieDate = movie.release_date()
	say "" + movieTitle + " wurde am " + movieDate + " released."
	request_completed
	
  listen_for /was schaust so deppert(.*)/i do |movieTitle|
	say "Du kannst von mir so ah Watschn habn, dast dich anscheisst und anbrunzt gemeinsam, gschissana!" + movieDate + " released."
	request_completed
  end
end
