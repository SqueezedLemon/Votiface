import 'package:flutter/material.dart';

class SamanupatikCard extends StatefulWidget {
  final String party_name;
  final String party_url;
  final bool isSelectable;
  final int selectedIndex;
  final Function selectionCallback;
  const SamanupatikCard({
    Key? key,
    required this.party_name,
    required this.party_url,
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
            backgroundImage: AssetImage(widget.party_url),
          ),
          title: Text(
            widget.party_name,
            softWrap: false,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black45,
              fontSize: 30,
            ),
          ),
        )
      ),
    );
  }
}
