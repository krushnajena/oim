import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:oim/constants/constant.dart';

import 'package:oim/constants/urls.dart';

class SellerImagesCarousel extends StatefulWidget {
  final List images;
  SellerImagesCarousel(this.images);

  @override
  _SellerImagesCarouselState createState() => _SellerImagesCarouselState();
}

class _SellerImagesCarouselState extends State<SellerImagesCarousel> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: 180,
          width: size.width,
          child: CarouselSlider(
            options: CarouselOptions(
                aspectRatio: 10.0,
                enlargeCenterPage: true,
                viewportFraction: 1,
                height: 200,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 4),
                autoPlayAnimationDuration: Duration(milliseconds: 500),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: [
              for (String image in widget.images)
                carouselItemBuilder(context, image, size)
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int imageIndex
                in Iterable<int>.generate(widget.images.length).toList())
              dotIndicatorBuilder(_current, imageIndex)
          ],
        ),
      ],
    );
  }

  Widget carouselItemBuilder(BuildContext context, String image, Size size) {
    return InkWell(
      child: Image.network(
        image,
        width: MediaQuery.of(context).size.width,
      ),
      onTap: () {
        // Navigator.pushNamed(context, onClickedRoute);
      },
    );
  }

  Widget dotIndicatorBuilder(activeIndex, currentIndex) {
    return Container(
      width: 14.0,
      height: 5.0,
      margin: EdgeInsets.fromLTRB(8.0, 5.0, 5.0, 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
        shape: BoxShape.rectangle,
        color: currentIndex == activeIndex
            ? Color.fromRGBO(0, 0, 0, 0.9)
            : Color.fromRGBO(0, 0, 0, 0.4),
      ),
    );
  }
}
