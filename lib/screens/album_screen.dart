import 'package:flutter/material.dart';
import 'package:my_gallery_app/screens/view_media_screen.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class AlbumScreen extends StatefulWidget {
  Album album;
  AlbumScreen({Key? key, required this.album}) : super(key: key);

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMedia();
  }

  List<Medium> mediaList = [];

  _loadMedia() async {
    MediaPage mediaPage = await widget.album.listMedia();
    mediaList = mediaPage.items;
    setState(() {
      mediaList;
    });
  }

  @override
  Widget build(BuildContext context) {
    double imgSize = (MediaQuery.of(context).size.width - 30) / 3;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.album.name}"),
      ),
      body: Container(
        margin: const EdgeInsets.all(5.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 0.75),
            itemCount: mediaList.length,
            itemBuilder: (context, index) {
              Medium media = mediaList[index];

              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewMediaScreen(medium: media)));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: ThumbnailProvider(
                        mediumType: media.mediumType,
                        highQuality: true,
                        mediumId: media.id),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
