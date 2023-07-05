import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app_bloc/constants/constants.dart';
import 'package:notes_app_bloc/features/components/date_tile.dart';
import 'package:notes_app_bloc/services/hive_serivces.dart';
import 'package:notes_app_bloc/model/todo_model.dart';
import '../components/note_tile.dart';

class AllNotesView extends StatefulWidget {
  const AllNotesView({super.key});

  @override
  State<AllNotesView> createState() => _AllNotesViewState();
}

class _AllNotesViewState extends State<AllNotesView> {
  //controller for audio_waveforms to record and play auido
  late PlayerController playerController;

  //variable to check if voice is being recorded and alter UI with respect to it.
  bool isRecording = false;

  //new note textField controller
  TextEditingController textEditingController = TextEditingController();

  //ValueNotifier for delete todo future.
  ValueNotifier<bool> deleteTodo = ValueNotifier(true);

  //ValueNotifier for delete all todo future.
  ValueNotifier<bool> deleteAllTodo = ValueNotifier(true);

  //Hive instance for todos box.
  late Box todosBox;

  bool isLoading = true;

  //provide the default priority for todos as low.
  String priority = 'low';

  //toogle FAB to switch b/w end float and center docked FAB.
  bool toogleFab = false;

  //to compare with new values of todo's dateTime.
  DateTime date = DateTime(1999, 01, 01);

  @override
  void initState() {
    HiveServices.initializeDB(); //init hive instance
    playerController = PlayerController();
    getTodos();
    super.initState();
  }

  void getTodos() async {
    todosBox = await Hive.openBox('todos');
    setState(
      () {
        isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //animate FAB
      floatingActionButtonLocation: toogleFab
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endFloat,
      resizeToAvoidBottomInset: false,
      floatingActionButton: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AnimatedContainer(
          width: toogleFab ? MediaQuery.of(context).size.width : 56,
          height: 56,
          duration: const Duration(milliseconds: 500),
          child: GestureDetector(
            onTap: () {
              (toogleFab && textEditingController.text.isNotEmpty)
                  ? HiveServices.addTodo(
                      textEditingController.text.hashCode,
                      TodoModel(
                        body: textEditingController.text,
                        isCompleted: false,
                        priority: priority,
                        dateTime: DateTime.now(),
                      ),
                    )
                  : null;
              setState(
                () {
                  toogleFab = !toogleFab;
                  textEditingController.text = '';
                },
              );
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(blurRadius: 2, color: Colors.black38),
                ],
                color: Colors.blue[500],
                shape: toogleFab ? BoxShape.rectangle : BoxShape.circle,
              ),
              child: toogleFab
                  ? const Text(
                      'Add Todo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Todos',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton(
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
            itemBuilder: (context) {
              return List.generate(
                1,
                (index) => PopupMenuItem(
                  onTap: () {
                    deleteAllTodo.value = !deleteAllTodo.value;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 3),
                        content: const Text('All todos cleared.'),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            deleteAllTodo.value = !deleteAllTodo.value;
                          },
                        ),
                      ),
                    );
                    deleteAllTodos(context);
                    // HiveServices.clearAllTodos();
                  },
                  child: const Text('Remove all.'),
                ),
                growable: false,
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) //show a CPI if the hive DB is not loaded.
          : SafeArea(
              maintainBottomViewPadding: false,
              child: Column(
                children: [
                  Visibility(
                    visible: toogleFab,
                    child: AnimatedContainer(
                      curve: Curves.linear,
                      duration: const Duration(milliseconds: 800),
                      child: (isRecording)
                          ? ListTile(
                              leading: IconButton(
                                icon: const Icon(
                                  Icons.mic,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => setState(() {
                                  isRecording = false;
                                }),
                              ),
                              title: AudioFileWaveforms(
                                size: const Size.fromWidth(30),
                                playerController: playerController,
                              ),
                            )
                          : ListTile(
                              dense: true,
                              title: TextField(
                                minLines: 1,
                                maxLines: 3,
                                textInputAction: TextInputAction.newline,
                                onSubmitted: (value) => setState(
                                  () {
                                    toogleFab = !toogleFab;
                                  },
                                ),
                                controller: textEditingController,
                                autofocus: true,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.mic,
                                        color: Colors.black87,
                                      ),
                                      onPressed: () {
                                        setState(
                                          () {
                                            isRecording = true;
                                          },
                                        );
                                        //notifi recording and start recording.
                                      },
                                    ),
                                    hintText: 'Write something...'),
                              ),

                              //***************set priority for each task button on add todo textField */
                              trailing: PopupMenuButton(
                                elevation: 1,
                                onSelected: (value) {
                                  priority = value;
                                },
                                itemBuilder: (context) {
                                  return List.generate(
                                    3,
                                    (index) => PopupMenuItem(
                                      child: Text(
                                        TextConstants.priorityLabels[index],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      onTap: () {
                                        priority =
                                            TextConstants.priorityLabels[index];
                                        setState(() {});
                                      },
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.label_important,
                                  color: priorityIconColor(priority),
                                ),
                              ),
                              //***************set priority for each task button on add todo textField */
                            ),
                    ),
                  ),
                  (todosBox.isEmpty)
                      ? Visibility(
                          visible: !toogleFab,
                          child: const Center(
                            heightFactor: 30,
                            child: Text('Nothing to show here. Add todos.'),
                          ),
                        )
                      : Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: todosBox.listenable(),
                            builder: (context, value, child) {
                              List todos = todosBox.values.toList();
                              todos.sort(
                                (b, a) => a.dateTime.compareTo(b.dateTime),
                              );
                              return ListView.separated(
                                padding: const EdgeInsets.only(bottom: 112),
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  thickness: 0.2,
                                  height: 0,
                                  color: Colors.black38,
                                ),
                                itemCount: todos.length,
                                itemBuilder: (context, index) {
                                  TodoModel todo = todos[index];
                                  Widget todoListView = Column(
                                    children: [
                                      (todo.dateTime!.day != date.day ||
                                              index == 0)
                                          ? DateTile(
                                              date: todo.dateTime!,
                                            )
                                          : const SizedBox.shrink(),
                                      Dismissible(
                                        resizeDuration:
                                            const Duration(milliseconds: 800),
                                        background: Container(
                                          color: Colors.blue[600],
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Removed!',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        key: UniqueKey(),
                                        onDismissed: (direction) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  'Todo has been removed!'),
                                              action: SnackBarAction(
                                                label: 'UNDO',
                                                onPressed: () {
                                                  deleteTodo.value =
                                                      !deleteTodo.value;
                                                },
                                              ),
                                            ),
                                          );
                                          removeTodo(todo.body, context);
                                        },
                                        child: NoteTile(
                                          dateTime: todo.dateTime!,
                                          priority: todo.priority,
                                          isChecked: todo.isCompleted,
                                          note: todo.body,
                                        ),
                                      ),
                                    ],
                                  );
                                  date = todo.dateTime!;
                                  return ValueListenableBuilder(
                                    valueListenable: deleteAllTodo,
                                    builder: (context, value, child) {
                                      return (deleteAllTodo.value)
                                          ? todoListView
                                          : const SizedBox.shrink();
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  void onComplete() {
    textEditingController.text = '';
  }

  void deleteAllTodos(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        (!deleteAllTodo.value) ? HiveServices.clearAllTodos() : null;
        setState(() {});
        deleteAllTodo.value = true;
      },
    );
  }

  void removeTodo(String todo, BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        (deleteTodo.value) ? HiveServices.deleteTodo(todo.hashCode) : null;
        setState(() {});
        deleteTodo.value = true;
      },
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
}
