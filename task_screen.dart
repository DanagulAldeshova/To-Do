import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences кітапханасын қосу (мәліметтерді локалды сақтау үшін).
import 'task.dart'; // Task моделін қосу.

// TaskScreen негізгі экранының күйі сақталатын StatefulWidget класс.
class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

// TaskScreen экранының күйін сақтау және басқару класы.
class _TaskScreenState extends State<TaskScreen> {
  List<Task> _tasks = []; // Тапсырмалардың тізімі.
  bool _showCompleted = false; // Тапсырмалардың орындалғанын көрсету/жасыру.

  final TextEditingController _titleController = TextEditingController(); // Атау өрісінің басқарушысы.
  final TextEditingController _descriptionController = TextEditingController(); // Сипаттама өрісінің басқарушысы.
  DateTime? _selectedDate; // Таңдалған күн.

  @override
  void initState() {
    super.initState();
    _tapstyrmalardyJukteu(); // Тапсырмаларды жүктеу.
  }

  // Тапсырмаларды жүктеу немесе алдын ала қосу.
  Future<void> _tapstyrmalardyJukteu() async {
    final prefs = await SharedPreferences.getInstance(); // SharedPreferences инстансын алу.
    final List<String>? storedTasks = prefs.getStringList('tasks'); // Локалды сақталған тапсырмалар.

    if (storedTasks != null && storedTasks.isNotEmpty) {
      setState(() {
        // Сақталған тапсырмаларды қайта құру.
        _tasks = storedTasks.map((taskString) {
          final Map<String, dynamic> map = taskString
              .split(';')
              .asMap()
              .map((_, value) {
            final parts = value.split(':');
            return MapEntry(parts[0], parts[1]);
          })
              .cast<String, dynamic>();
          return Task.fromMap(map);
        }).toList();
      });
    } else {
      setState(() {
        // Егер сақталған мәліметтер болмаса, алдын ала дайын тапсырмалар қосылады.
        _tasks = [
          Task(
            title: "1. UI дизайн жасау",
            description: "Экрандар арасындағы ауысулар, түймелер және мәтіндер үшін визуалды компоненттерді пайдалану.",
            deadline: "2024-11-20",
          ),
          Task(
            title: "2. Деректерді локалды сақтау",
            description: "Деректерді локалды сақтау және оларды шығару.",
            deadline: "2024-11-30",
          ),
          Task(
            title: "3. REST API арқылы деректер алу",
            description: "API арқылы деректерді алу, көрсету және қате өңдеу.",
            deadline: "2025-11-20",
          ),
          Task(
            title: "4. Тізімдермен жұмыс",
            description: "ListView арқылы үлкен тізімдерге интерактивтілік қосу.",
            deadline: "2024-11-21",
          ),
          Task(
            title: "5. Анимация жасау",
            description: "Анимациялар арқылы қолданушының тәжірибесін жақсарту.",
            deadline: "2026-10-20",
          ),
          Task(
            title: "6. Форма мен валидация",
            description: "Форма жасау және деректердің дұрыстығын тексеру.",
            deadline: "2024-12-01",
          ),
        ];
      });
      _tapstyrmalardySaqtau(); // Алдын ала дайын тапсырмаларды локалды сақтау.
    }
  }

  // Тапсырмаларды локалды сақтау.
  Future<void> _tapstyrmalardySaqtau() async {
    final prefs = await SharedPreferences.getInstance(); // SharedPreferences инстансын алу.
    final List<String> taskStrings = _tasks
        .map((task) => task.toMap().entries.map((e) => '${e.key}:${e.value}').join(';'))
        .toList(); // Тапсырмаларды сақтау форматына түрлендіру.
    await prefs.setStringList('tasks', taskStrings); // Тапсырмаларды сақтау.
  }

  // Тапсырма қосу немесе өңдеу.
  Future<void> _tapstyrmaKosuNemeseOndeu({int? index}) async {
    final isEdit = index != null; // Редакциялау режимін тексеру.
    if (isEdit) {
      // Егер редакциялау режимінде болса, өрістерге бұрынғы мәліметтер толтырылады.
      _titleController.text = _tasks[index].title;
      _descriptionController.text = _tasks[index].description;
      _selectedDate = DateTime.parse(_tasks[index].deadline);
    } else {
      // Егер жаңа тапсырма қосу режимінде болса, өрістер тазаланады.
      _titleController.clear();
      _descriptionController.clear();
      _selectedDate = null;
    }

    // Диалогтық терезе көрсету.
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Дөңгеленген шеттер.
        ),
        title: Text(
          isEdit ? 'Тапсырманы өңдеу' : 'Тапсырма қосу',
          style: TextStyle(color: Colors.indigo),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController, // Атау енгізу өрісі.
              decoration: InputDecoration(
                labelText: 'Атау',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController, // Сипаттама енгізу өрісі.
              decoration: InputDecoration(
                labelText: 'Сипаттама',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'Аяқталу уақыты таңдалмаған' // Егер күн таңдалмаса.
                        : 'Күні: ${_selectedDate!.toIso8601String().split('T').first}', // Таңдалған күн.
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context, // Күн таңдау виджеті.
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked; // Таңдалған күнді сақтау.
                      });
                    }
                  },
                  child: Text('Күнді таңдау'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Болдырмау батырмасы.
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Болдырмау',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
          // Қосу/Сақтау батырмасы.
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty &&
                  _descriptionController.text.isNotEmpty &&
                  _selectedDate != null) {
                setState(() {
                  if (isEdit) {
                    _tasks[index!] = Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      deadline: _selectedDate!.toIso8601String().split('T').first,
                      isCompleted: _tasks[index!].isCompleted,
                    );
                  } else {
                    _tasks.add(Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      deadline: _selectedDate!.toIso8601String().split('T').first,
                    ));
                  }
                });
                _tapstyrmalardySaqtau(); // Өзгерістерді сақтау.
                Navigator.of(context).pop(); // Диалогты жабу.
              }
            },
            child: Text(isEdit ? 'Сақтау' : 'Қосу'),
          ),
        ],
      ),
    );
  }

  // Тапсырманың орындалу күйін өзгерту.
  Future<void> _tapstyrmanyOryndauKuinOzger(int index) async {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    _tapstyrmalardySaqtau(); // Өзгерістерді сақтау.
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _tasks.where((task) => task.isCompleted == _showCompleted).toList();

    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50, // Экранның фоны.
      appBar: AppBar(
        title: Row(
          children: [
            Image.network(
              'https://soft-ok.net/uploads/posts/2015-08/1440669018_todo-cloud-3-0-5.png',
              width: 40, // Логотип өлшемдері.
              height: 40,
            ),
            Text('Тапсырмалар тізімі'), // Қолданба тақырыбы.
            SizedBox(width: 10),
            Switch(
              value: _showCompleted, // Орындалған тапсырмаларды көрсету батырмасы.
              onChanged: (value) {
                setState(() {
                  _showCompleted = value; // Көрсету күйін өзгерту.
                });
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.red,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length, // Көрсетуге арналған тапсырмалар саны.
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                final taskIndex = _tasks.indexOf(task);

                return Card(
                  color: task.isCompleted ? Colors.green.shade500 : Colors.white,
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough // Егер тапсырма орындалған болса, сызық сызу.
                            : TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('${task.description}\n${task.deadline}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Редакциялау батырмасы.
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _tapstyrmaKosuNemeseOndeu(index: taskIndex),
                        ),
                        // Тапсырма орындалу күйін өзгерту батырмасы.
                        IconButton(
                          icon: Icon(
                            task.isCompleted
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                          ),
                          onPressed: () => _tapstyrmanyOryndauKuinOzger(taskIndex),
                        ),
                        // Тапсырманы жою батырмасы.
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _tasks.removeAt(taskIndex); // Тапсырманы тізімнен жою.
                            });
                            _tapstyrmalardySaqtau(); // Өзгерістерді сақтау.
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Тапсырма қосу батырмасы.
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tapstyrmaKosuNemeseOndeu(),
        child: Icon(Icons.add),
      ),
    );
  }
}

