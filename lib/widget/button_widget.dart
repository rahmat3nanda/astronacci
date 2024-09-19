/*
 * *
 *  * button_widget.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 03:11
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/13/2024, 01:49
 *
 */

import 'package:flutter/material.dart';
import 'package:astronacci/common/styles.dart';

class ButtonWidget extends StatefulWidget {
  final Widget child;
  final Function()? onTap;
  final Color? color;
  final double? width;
  final BoxBorder? border;
  final BorderRadius? radius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool withShadow;
  final bool isActive;

  const ButtonWidget({
    super.key,
    required this.child,
    required this.onTap,
    this.color,
    this.width,
    this.border,
    this.radius,
    this.margin,
    this.padding,
    this.withShadow = true,
    this.isActive = true,
  });

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.margin ?? const EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        borderRadius: widget.radius ??
            const BorderRadius.all(
              Radius.circular(8.0),
            ),
        color: Colors.transparent,
        boxShadow: [
          if (widget.withShadow)
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.isActive
                ? widget.color ?? AppColor.secondary
                : Colors.grey,
            borderRadius: widget.radius ??
                const BorderRadius.all(
                  Radius.circular(8.0),
                ),
            border: widget.border,
          ),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            onTap: widget.isActive ? widget.onTap : null,
            child: Padding(
              padding: widget.padding ??
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
