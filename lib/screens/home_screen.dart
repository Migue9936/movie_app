import 'package:flutter/material.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/search/search_delegate.dart';
import 'package:movies_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    
    return  Scaffold(
      appBar: AppBar(
        title: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 200), //ancho máximo del contenedor
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: precacheImage(AssetImage('assets/cinesunidos.png'), context),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return FadeInImage(
                        placeholder: AssetImage('assets/placeholder_image.png'),
                        image: AssetImage('assets/cinesunidos.png'),
                        height: 60,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                SizedBox(width: 8),
                Text('Cinesunidos'),
              ],
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()),
          ) 
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Main Cards
            CardSwiper(movies: moviesProvider.onDisplayMovies),
            //Movies Sliders
            MovieSlider(movies: moviesProvider.popularMovies,title: 'Most Popular!'),
          ]
        ),
      ),
    );
  }
}
