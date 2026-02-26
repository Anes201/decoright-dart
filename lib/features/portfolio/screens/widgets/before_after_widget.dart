import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BeforeAfterWidget extends StatefulWidget {
  final String beforeImage;
  final String afterImage;
  final double height;

  const BeforeAfterWidget({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    this.height = 250,
  });

  @override
  State<BeforeAfterWidget> createState() => _BeforeAfterWidgetState();
}

class _BeforeAfterWidgetState extends State<BeforeAfterWidget> {
  double _clipFactor = 0.5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _clipFactor = (_clipFactor + details.delta.dx / width).clamp(0.0, 1.0);
            });
          },
          child: SizedBox(
            height: widget.height,
            width: width,
            child: Stack(
              children: [
                /// After Image (Background)
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: widget.afterImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey[200]),
                  ),
                ),

                /// Before Image (Clipped)
                Positioned.fill(
                  child: ClipRect(
                    clipper: _BeforeClipper(_clipFactor),
                    child: CachedNetworkImage(
                      imageUrl: widget.beforeImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey[200]),
                    ),
                  ),
                ),

                /// Slider Handle
                Positioned(
                  left: width * _clipFactor - 1,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  left: width * _clipFactor - 15,
                  top: widget.height / 2 - 15,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.unfold_more, size: 20, color: Colors.grey),
                  ),
                ),

                /// Labels
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: _buildLabel('BEFORE'),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: _buildLabel('AFTER'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _BeforeClipper extends CustomClipper<Rect> {
  final double factor;
  _BeforeClipper(this.factor);

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * factor, size.height);

  @override
  bool shouldReclip(_BeforeClipper oldClipper) => oldClipper.factor != factor;
}
