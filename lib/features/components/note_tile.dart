import 'package:flutter/material.dart';
import 'package:notes_app_bloc/model/todo_model.dart';
import 'package:notes_app_bloc/services/hive_serivces.dart';
import '../../constants/constants.dart';

class NoteTile extends StatefulWidget {
  final bool isChecked;
  final String note;
  final String priority;
  final DateTime dateTime;
  const NoteTile({
    super.key,
    required this.priority,
    required this.isChecked,
    required this.note,
    required this.dateTime,
  });

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ValueNotifier<bool> isComplete = ValueNotifier(widget.isChecked);
    return ValueListenableBuilder(
      valueListenable: isComplete,
      builder: (context, value, child) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () {
            isComplete.value = !isComplete.value;
            update(isComplete.value);
          },
          leading: Checkbox(
            activeColor: Colors.blue[200],
            onChanged: (value) {
              isComplete.value = value!;
              update(isComplete.value);
            },
            value: isComplete.value,
          ),
          title: Text(
            widget.note,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              decoration: (isComplete.value)
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          trailing: PopupMenuButton(
            itemBuilder: (context) {
              return List.generate(
                3,
                (index) => PopupMenuItem(
                  child: Text(
                    TextConstants.priorityLabels[index],
                  ),
                  onTap: () {
                    HiveServices.updateTodo(
                      widget.note.hashCode,
                      TodoModel(
                        body: widget.note,
                        isCompleted: isComplete.value,
                        priority: TextConstants.priorityLabels[index],
                        dateTime: widget.dateTime,
                      ),
                    );
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: (isComplete.value)
                  ? Text(
                      'Done!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: priorityIconColor(widget.priority),
                      ),
                    )
                  : Icon(
                      Icons.label_important,
                      // size: 10,
                      color: priorityIconColor(widget.priority),
                    ),
            ),
          ),
        );
      },
    );
  }

  void update(bool isCompleted) {
    HiveServices.updateTodo(
      widget.note.hashCode,
      TodoModel(
        body: widget.note,
        isCompleted: isCompleted,
        priority: widget.priority,
        dateTime: widget.dateTime,
      ),
    );
  }

  Color priorityIconColor(String priority) {
    if (priority == 'high') {
      return ColorConstants.highPriorityColor;
    } else if (priority == 'medium') {
      return ColorConstants.mediumPriorityColor;
    } else {
      return ColorConstants.lowPriorityColor;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
