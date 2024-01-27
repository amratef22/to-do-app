import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/cubits/states.dart';
import 'package:to_do/screens/archived_task.dart';
import 'package:to_do/screens/done_task.dart';
import 'package:to_do/screens/new_task.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit():super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);

  int currentIndex=0;

  List<Widget> screens=
  [
    const NewTask(),
    const DoneTask(),
    const ArchivedTask(),
  ];
  List<String>text=
  [
    ' New Task',
    'Done Task',
    'Archived Task',
  ];

  void changeIndex(int index)
  {
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  bool isBottomSheetShown = false;
  IconData fabIcon=Icons.edit;

  void updateData({
  required String status,
  required int id,
})async
  {
     database.rawUpdate(
        'UPDATE tasks SET status = ?  WHERE id = ?',
        [status, id],
    ).then((value)
     {
       getDataFromDatabase(database);
       emit(AppUpdateDatabaseState());
     });
  }

  void deleteData({
    required int id,
  })async
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }


  void createDatabase()
  {
    openDatabase(


        'todo.db',
        version: 1,


        onCreate: (database, version)
        {
          print('database created');
           database.execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY ,title TEXT,date TEXT,time TEXT,status TEXT) ')
              .then((value){
            print('table created');
          }).catchError((error){
            print('Error when creating table ${error.toString()}');
          });
        },


        onOpen: (database)
        {
          getDataFromDatabase(database);
          print('database opened');
        }
    ).then((value)
    {
      database=value;
      emit(AppCreateDatabaseState());
    });
  }
  insertDatabase({
    required String title,
    required String time,
    required String date,
  })async
  {
    await database.transaction((txn)
    {
      return txn.rawInsert(
          'INSERT INTO tasks (title,date,time,status) VALUES("$title","$date","$time","new")'
      ).then((value)
      {
        // ignore: avoid_print
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error) {
        // ignore: avoid_print
        print('error when inserting new record ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database)
  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetDatabaseState());
     database.rawQuery('SELECT * FROM tasks').then((value)
     {
       value.forEach((element)
       {

         if(element['status'] == 'new')
         {
           newTasks.add(element);
         }

         else if(element['status'] == 'done')
         {
           doneTasks.add(element);
         }

         else
           {
           archivedTasks.add(element);
           }
       });
       emit(AppGetDatabaseState());

     });
  }

  void changeBottomSheetShown({
    required bool isShown,
    required IconData icon,
})
  {
    isBottomSheetShown=isShown;
    fabIcon=icon;

    emit(AppChangeBottomSheetState());
  }
}