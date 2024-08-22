import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_gallery_app/screens/album_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Album> albums = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermissions();
  }

  _requestPermissions() async {
    if (Platform.isAndroid) {
      if ((await Permission.photos.request().isGranted ||
              await Permission.storage.request().isGranted) &&
          await Permission.videos.request().isGranted) {
        _loadAllAlbums();
      } else {
        print("Permission not granted");
      }
    }
  }

  _loadAllAlbums() async {
    albums = await PhotoGallery.listAlbums();
    setState(() {
      albums;
    });
  }

  @override
  Widget build(BuildContext context) {
    double imgSize = (MediaQuery.of(context).size.width - 30) / 3;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Gallery"),
      ),
      body: Container(
        margin: const EdgeInsets.all(5.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 0.75),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              Album album = albums[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AlbumScreen(album: album)));
                },
                child: Column(
                  children: [
                    SizedBox(
                      width: imgSize,
                      height: imgSize,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: AlbumThumbnailProvider(
                              album: album, highQuality: true),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${album.name}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16.0),
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${album.count}",
                          style: TextStyle(fontSize: 12.0),
                        ))
                  ],
                ),
              );
            }),
      ),
    );
  }
}
