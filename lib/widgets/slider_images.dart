import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class SliderImages extends StatefulWidget {
  final List<String> imagesToSliders;
  final String productUrl;

  SliderImages({
    this.imagesToSliders,
    this.productUrl,
  });

  @override
  _SliderImagesState createState() => _SliderImagesState();
}

class _SliderImagesState extends State<SliderImages> {
  int _current = 0;

  void _fullScreenImage({image}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            body: PhotoView(
              imageProvider: widget.imagesToSliders.isEmpty
                  ? AssetImage('images/empty_url.png')
                  : image.toString().contains('https://')
                      ? NetworkImage(image)
                      : AssetImage(image),
            ),
          );
        },
      ),
    );
  }

  Widget _oneImageProduct() {
    // Gdy jest tylko jedno zdj w aukcji.
    return Hero(
      tag: widget.imagesToSliders.isEmpty
          ? '${widget.productUrl}-Image'
          : widget.imagesToSliders[0],
      child: widget.imagesToSliders.isEmpty
          ? Image.asset('images/empty_url.png')
          : widget.imagesToSliders[0].toString().contains('https://')
              ? Image.network(widget.imagesToSliders[0])
              : Image.asset(widget.imagesToSliders[0]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.imagesToSliders.length == 1
        ? InkWell(
            onTap: () {
              _fullScreenImage(image: widget.imagesToSliders[0]);
            },
            child: _oneImageProduct(),
          )
        : Column(children: [
            Expanded(
              child: CarouselSlider(
                items: widget.imagesToSliders.map((i) {
                  if (i == widget.imagesToSliders[0]) {
                    return InkWell(
                      onTap: () {
                        _fullScreenImage(image: i);
                      },
                      child: _oneImageProduct(),
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        _fullScreenImage(image: i);
                      },
                      child: widget.imagesToSliders.isEmpty
                          ? Image.asset('images/empty_url.png')
                          : i.toString().contains('https://')
                              ? Image.network(i)
                              : Image.asset(i),
                    );
                  }
                }).toList(),
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imagesToSliders.map((url) {
                int index = widget.imagesToSliders.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ]);
  }
}
