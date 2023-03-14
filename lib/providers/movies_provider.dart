
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:movies_app/helpers/debouncer.dart';
import 'package:movies_app/models/models.dart';

class MoviesProvider  extends ChangeNotifier {
  final String _baseUrl  = 'api.themoviedb.org';
  final String _apiKey   = '6a0893fb5135742a4dde25818dbcb903';
  final String _lenguage = 'en-US';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int,List<Cast>> movieCast={};
  List<Movie> searchMovies = [];


  int _popularPages = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 100),
  );
  
  final StreamController<List<Movie>> _suggestionsStreamController = StreamController.broadcast();
  
  Stream<List<Movie>> get suggestionStream => _suggestionsStreamController.stream;



  MoviesProvider(){
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint,[int page=1] ) async{
     final url = Uri.https(_baseUrl, endpoint, {
      'api_key' : _apiKey,
      'language': _lenguage,
      'page'    : '$page',
      
    });

  // Await the http get response, then decode the json-formatted response.
    final  response = await http.get(url);
    return response.body;
  }  
  
  getOnDisplayMovies() async{
   
    var jsonData = await _getJsonData('/3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    
    onDisplayMovies =nowPlayingResponse.results;

    notifyListeners();

  }

   getPopularMovies() async{
    _popularPages++;
    var jsonData = await _getJsonData('/3/movie/popular',_popularPages);
    final popularResponse = PopularResponse.fromJson(jsonData);
    
    popularMovies = [...popularMovies, ...popularResponse.results];


    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async{

    if (movieCast.containsKey(movieId)) return movieCast[movieId]!; 
    
    var jsonData = await _getJsonData('/3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    movieCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;


  }

  Future <List<Movie>> getSearchMovie(String query) async {
    
    final url =  Uri.https(_baseUrl, '/3/search/movie', {
      'api_key' : _apiKey,
      'language': _lenguage,
      'query'   : query
    });

    final  response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm ){
    debouncer.value = '';
    debouncer.onValue = (value)async{
      final results = await getSearchMovie(value);
      _suggestionsStreamController.add(results);
    };
    final timer = Timer.periodic(const Duration(milliseconds: 50), (_) { 
      debouncer.value = searchTerm;

    });

    Future.delayed(const Duration(milliseconds: 51)).then((_) => timer.cancel());

  }

}