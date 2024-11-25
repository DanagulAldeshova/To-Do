import 'package:flutter/material.dart';
import 'task_screen.dart'; // TaskScreen экранына сілтеме

// Негізгі қосымшаны іске қосу.
void main() => runApp(TaskApp());

// Негізгі қосымшаның класы.
class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Қолданбаға арналған негізгі тақырыпты баптау.
      theme: ThemeData(
        primarySwatch: Colors.indigo, // Қолданбаның негізгі түсі.
        scaffoldBackgroundColor: Colors.grey.shade200, // Негізгі экранның артқы фонының түсі.
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo, // Қолданбаның жоғарғы тақырыбының түсі.
          elevation: 5, // Жоғарғы тақырыптың көлеңкесі.
          titleTextStyle: TextStyle(
            fontSize: 22, // Тақырып мәтінінің өлшемі.
            fontWeight: FontWeight.bold, // Тақырып мәтінінің қалыңдығы.
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo, // Шағын жылжымалы батырманың түсі.
        ),
        cardTheme: CardTheme(
          margin: EdgeInsets.all(8), // Карточка жиектерінің ара қашықтығы.
          elevation: 5, // Карточка көлеңкесінің қарқындылығы.
          shadowColor: Colors.indigo.withOpacity(0.3), // Карточка көлеңкесінің түсі.
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Карточканың бұрыштарын дөңгелектеу.
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.indigo, // Текст батырмасының түсі.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Батырманың бұрыштарын дөңгелектеу.
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Батырманың ішкі ара қашықтығы.
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo, // Көтерілген батырманың негізгі түсі.
            foregroundColor: Colors.white, // Мәтін түсі.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Батырманың бұрыштарын дөңгелектеу.
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Батырманың ішкі ара қашықтығы.
          ),
        ),
      ),
      home: TaskScreen(), // Негізгі экран ретінде TaskScreen класын көрсету.
    );
  }
}

