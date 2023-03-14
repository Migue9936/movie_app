import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/widgets/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailsScreen extends StatelessWidget {
   
  const DetailsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;



    return    Scaffold(
      body: CustomScrollView(
        slivers: [
           _CustomAppBar(movie: movie),
          
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(movie),
              _Overview(movie),
              const SizedBox(height: 10,),
               CardsCasting(movie.id)
            ])
          )
          
        ],
      )
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    return  SliverAppBar(
      backgroundColor: Colors.black26,
      expandedHeight: 350,
      floating: false,
      pinned: true,
      flexibleSpace:   FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        // ignore: sized_box_for_whitespace
        title: Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            color: Colors.black12,
            padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
            child: Text(movie.title,style: const TextStyle(fontSize: 16),textAlign: TextAlign.center,),
          ),
        background:  FadeInImage(
          placeholder:const AssetImage('assets/loading.gif'), 
          image: NetworkImage(movie.fullBackDropPath),
          fit:BoxFit.cover,        
        ),
      ),

    );
  }
}

class _PosterAndTitle extends StatelessWidget {
    
    final Movie movie;

  const _PosterAndTitle( this.movie);


  @override
  Widget build(BuildContext context) {

  
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder:const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullImagePath),
                height: 150,
              ),
            ),
          ),
          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(movie.title,style: textTheme.headlineSmall, overflow: TextOverflow.ellipsis, maxLines: 2),
                Text(movie.originalTitle,style: textTheme.titleMedium, overflow: TextOverflow.ellipsis, maxLines: 2),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: movie.voteAverage / 2,
                      ignoreGestures: true,
                      allowHalfRating: true,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5, 
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        
                      ), onRatingUpdate: (double value) {  },
                    ),
                    const SizedBox(width: 3),
                    Text('${movie.voteAverage.toInt()}',style: textTheme.titleLarge),
                  ],
                ),
              ]

            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview(this.movie);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child:  Text(movie.overview,
          textAlign: TextAlign.justify,
          style: textTheme.titleMedium,
        ),
    );
  }
}