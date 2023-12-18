import 'package:flutter/material.dart';
import 'package:flutter_app_advanced/models/models.dart';

class DetailsScreen extends StatefulWidget {
  final DataModel data;
  const DetailsScreen({super.key, required this.data});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black54),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(widget.data.title,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Hero(
                tag: widget.data.imageName,
                child: Container(
                    decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: AssetImage(
                        widget.data.imageName,
                      ),
                      fit: BoxFit.fill),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        color: Colors.black26)
                  ],
                )),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text("Price: \$${widget.data.price}",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
            ),
          ),
        ],
      ),
    );
  }
}
