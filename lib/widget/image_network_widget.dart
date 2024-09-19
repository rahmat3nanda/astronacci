/*
 * *
 *  * image_network_widget.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 18:54
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/13/2024, 00:14
 *
 */

import 'package:astronacci/common/constants.dart';
import 'package:astronacci/page/image_viewer_page.dart';
import 'package:astronacci/tool/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageNetworkWidget extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BorderRadius? radius;
  final bool clickable;
  final BoxFit fit;
  final BoxShape shape;
  final Color? color;
  final BoxBorder? border;
  final String? defaultImage;

  const ImageNetworkWidget({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.radius,
    this.clickable = true,
    this.fit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
    this.color,
    this.border,
    this.defaultImage,
  });

  @override
  State<ImageNetworkWidget> createState() => _ImageNetworkWidgetState();
}

class _ImageNetworkWidgetState extends State<ImageNetworkWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.clickable
        ? InkWell(
            child: _mainView(),
            onTap: () => Helper().jumpToPage(
              context,
              page: ImageViewerPage(url: widget.url),
            ),
          )
        : _mainView();
  }

  Widget _mainView() {
    return CachedNetworkImage(
      imageUrl: widget.url,
      imageBuilder: (c, image) => _imageView(image),
      placeholder: (c, url) =>
          _imageView(AssetImage(widget.defaultImage ?? AppImage.astronacciFill)),
      errorWidget: (c, url, e) =>
          _imageView(AssetImage(widget.defaultImage ?? AppImage.astronacciFill)),
    );
  }

  Widget _imageView(ImageProvider<Object> image) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: widget.radius,
        shape: widget.shape,
        color: widget.color,
        border: widget.border,
        image: DecorationImage(
          image: image,
          fit: widget.fit,
        ),
      ),
    );
  }
}
