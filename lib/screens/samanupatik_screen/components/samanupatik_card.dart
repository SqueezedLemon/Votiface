import 'package:flutter/material.dart';

class SamanupatikCard extends StatefulWidget {
  final String samanupatik_image_url;
  final String samanupatik_name;
  final String samanupatik_party_url;
  final String samanupatik_party_name;
  final bool isSelectable;
  final int selectedIndex;
  final Function selectionCallback;
  const SamanupatikCard({
    Key? key,
    required this.samanupatik_image_url,
    required this.samanupatik_name,
    required this.samanupatik_party_url,
    required this.samanupatik_party_name,
    required this.isSelectable,
    required this.selectedIndex,
    required this.selectionCallback,
  }) : super(key: key);

  @override
  State<SamanupatikCard> createState() => _SamanupatikCardState();
}

class _SamanupatikCardState extends State<SamanupatikCard> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = !widget.isSelectable;

    return GestureDetector(
      onTap: () {
        if (widget.isSelectable) {
          widget.selectionCallback(widget.selectedIndex);
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: isSelected ? Colors.blueAccent : Colors.grey[200],
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: AssetImage(widget.samanupatik_image_url),
          ),
          title: Text(
            widget.samanupatik_party_name,
            softWrap: false,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black45,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            widget.samanupatik_name,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black45,
              fontSize: 18,
            ),
          ),
          trailing: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.grey[200],
            backgroundImage: AssetImage(widget.samanupatik_party_url),
          ),
        ),
      ),
    );
  }
}
