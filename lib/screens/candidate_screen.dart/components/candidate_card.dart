import 'package:flutter/material.dart';

class CandidateCard extends StatefulWidget {
  final String candidate_image_url;
  final String candidate_name;
  final String candidate_party_url;
  final String candidate_party_name;
  final bool isSelectable;
  final int selectedIndex;
  final Function selectionCallback;
  const CandidateCard({
    Key? key,
    required this.candidate_image_url,
    required this.candidate_name,
    required this.candidate_party_url,
    required this.candidate_party_name,
    required this.isSelectable,
    required this.selectedIndex,
    required this.selectionCallback,
  }) : super(key: key);

  @override
  State<CandidateCard> createState() => _CandidateCardState();
}

class _CandidateCardState extends State<CandidateCard> {
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
            backgroundImage: AssetImage(widget.candidate_image_url),
          ),
          title: Text(
            widget.candidate_name,
            softWrap: false,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black45,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            widget.candidate_party_name,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black45,
              fontSize: 18,
            ),
          ),
          trailing: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.grey[200],
            backgroundImage: AssetImage(widget.candidate_party_url),
          ),
        ),
      ),
    );
  }
}
