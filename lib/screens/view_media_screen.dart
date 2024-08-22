import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';

class ViewMediaScreen extends StatefulWidget {
  Medium medium;
  ViewMediaScreen({Key? key, required this.medium}) : super(key: key);

  @override
  State<ViewMediaScreen> createState() => _ViewMediaScreenState();
}

class _ViewMediaScreenState extends State<ViewMediaScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadImageFile();
  }

  File? mediafile;

  _loadImageFile() async {
    mediafile = await widget.medium.getFile();
    setState(() {
      mediafile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.medium.filename}"),
        ),
        body: Center(
          child: mediafile != null ? Image.file(mediafile!) : Container(),
        ));
  }
}
