import 'package:flutter/material.dart';
import 'package:notes_app_bloc/extensions/extensions.dart';

class DateTile extends StatefulWidget {
  final DateTime date;
  const DateTile({required this.date, super.key});

  @override
  State<DateTile> createState() => _DateTileState();
}

class _DateTileState extends State<DateTile>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(blurRadius: 1, offset: Offset(0, 1), color: Colors.black12),
        ],
        color: Colors.blue[300],
      ),
      // height: 10,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.date.formatDate(),
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
