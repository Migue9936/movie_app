

import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {

  @override
  String? get searchFieldLabel => 'Search Movie ';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed:() => query = '' , icon: const Icon(Icons.close_rounded))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () {
          close(context, null);
      }, 
    );
  }

  @override
  Widget buildResults(BuildContext context) {
      return  const Text('Sisas BuildResult');
    
  }

  Widget _emptyContainer(){
    return Center(
         child: Icon(Icons.movie_creation_outlined,color: Colors.red.shade700,size: 150),
       );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
       return _emptyContainer();
     }

    final moviesProvider= Provider.of<MoviesProvider>(context);
    moviesProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        
        if (!snapshot.hasData) return _emptyContainer();
          
        final movies = snapshot.data!;
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, index) => _MovieItem(movies[index]),
        );
      },
    ); 
  }
  
}

class _MovieItem extends StatelessWidget {

  final Movie movie;
  
  const _MovieItem(this.movie);
   
  @override
  Widget build(BuildContext context) {
    movie.heroId= 'sisas2${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        
        child: FadeInImage(
            placeholder: const AssetImage('assets/no-image.jpg'), 
            image: NetworkImage(movie.fullImagePath),
            width: 50,
            fit: BoxFit.contain,
          ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context,'details',arguments: movie);
      },
    );
  }
}

