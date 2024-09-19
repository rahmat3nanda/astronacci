/*
 * *
 *  * image_viewer_page.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 18:54
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/13/2024, 00:14
 *
 */

import 'package:astronacci/widget/image_network_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageViewerPage extends StatefulWidget {
  final String url;

  const ImageViewerPage({super.key, required this.url});

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late TransformationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: Colors.black,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Center(
          child: InteractiveViewer(
            minScale: 0.1,
            maxScale: 4.0,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            transformationController: _controller,
            child: ImageNetworkWidget(
              url: widget.url,
              clickable: false,
              fit: BoxFit.fitWidth,
            ),
            onInteractionEnd: (d) => _controller.value = Matrix4.identity(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
