import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

const DEFAULT_COLORS = [
  // 빨강
  'F44336',
  // 주황
  'FF9800',
  // 노랑
  'FFEB3B',
  // 초록
  'FCAF50',
  // 파랑
  '2196F3',
  // 남
  '3F51B5',
  // 보라
  '9C27B0'
];

void main() async {
  // 초기화 됐는지 확인(원래는 runApp 실행이 되면 이 코드가 실행이 되는데 우리가 runApp전에
  // nitializeDateFormatting을 실행하기 때문에 또 한번의 초기화를 해줘야 한다
  WidgetsFlutterBinding.ensureInitialized();

  // 만약 runApp전에 다른 코드를 실행하려면 플러터 프레임워크가 준비 된 상태인지 확인 해야함 ↑
  await initializeDateFormatting();

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(database);

  final colors = await database.getCategoryColors();

  if (colors.isEmpty) {
    for (String hexCode in DEFAULT_COLORS) {
      await database.createCategoryColor(
        CategoryColorsCompanion(
          hexCode: Value(hexCode),
        ),
      );
    }
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'NotoSans'),
    home: const HomeScreen(),
  ));
}
