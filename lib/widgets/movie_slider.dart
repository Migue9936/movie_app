import 'package:flutter/material.dart';
import 'package:movies_app/models/movie.dart';

class MovieSlider extends StatelessWidget {
  final List <Movie> movies ;
  final String? title;

  const MovieSlider({super.key, required this.movies, this.title});
  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:   [
          //Movies Slider
          _TextMovieSlider(title: title),

          const SizedBox(height: 7,),
          //Popular Movies Slider
          _MoviePoster(movies: movies),
        ]
        ),
    );
  }
}

class _TextMovieSlider extends StatelessWidget {
  final String? title;

  const _TextMovieSlider({this.title});

  @override
  Widget build(BuildContext context) {
    if (title != null) {
      return Padding(padding: const EdgeInsets.symmetric(horizontal: 20),child: Text(title!,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)));
    }else{
      return const Center(
        child: Text(''),
      );
    } 
      
  }
}

class _MoviePoster extends StatelessWidget {
  
  final List <Movie> movies;
  
  const _MoviePoster({required this.movies});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {

          final movie = movies[index];

          movie.heroId = 'sisas${movie.id}';

          return Container(
            width: 130,
            height: 190,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children:  [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'details',arguments: movie),
                    child: Hero(
                      tag: movie.heroId!,
                      child: ClipRRect(
                        borderRadius:BorderRadius.circular(20) ,
                        child:  FadeInImage(
                        placeholder: const AssetImage('assets/no-image.jpg'), 
                          image: NetworkImage(movie.fullImagePath),
                          width: 130,
                          height: 190,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  
                   Text(
                    movie.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}