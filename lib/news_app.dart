import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do/constant/componants.dart';
import 'package:to_do/cubits/cubit.dart';
import 'package:to_do/cubits/states.dart';

class ToDOApp extends StatelessWidget
{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();
  DateTime selectedDate = DateTime.now();



  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) =>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit , AppStates>(
        listener: (BuildContext context , AppStates state)
        {
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context , AppStates state)
        {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.deepOrange,
              title: Center(child: Text(cubit.text[cubit.currentIndex])),
            ),
            body: ConditionalBuilder(
              condition: true,
              builder: (context)=>cubit.screens [cubit.currentIndex],
              fallback: (context)=>const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: ()
              {
                if(cubit.isBottomSheetShown)
                {
                  if(formKey.currentState!.validate())
                  {
                    cubit.insertDatabase
                      (
                        title: titleController.text,
                        time: titleController.text,
                        date: dateController.text,
                      );

                  }

                }else
                {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context)=> Container(
                          color: Colors.white,
                      padding: const EdgeInsets.all(20,),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children:
                          [
                            defaultFromField(
                              controller: titleController,
                              type: TextInputType.text,
                              label: 'task title',
                              prefix: Icons.title,
                              validate: 'title must not be empty',
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            defaultFromField(
                              controller: timeController,
                              type: TextInputType.datetime,
                              label: 'task time',
                              prefix: Icons.watch_later_rounded,
                              validate: 'time must not be empty',
                              onTap:()
                              {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value)
                                {
                                  timeController.text=value!.format(context).toString();
                                  print(value.format(context));
                                });
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            defaultFromField(
                              controller: dateController,
                              type: TextInputType.datetime,
                              label: 'task date',
                              prefix: Icons.calendar_today_outlined,
                              validate: 'date must not be empty',
                              onTap:()
                              {
                                showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2025),
                                ).then((value)
                                {
                                  dateController.text=DateFormat.yMMMd().format(value!);
                                });
                              },
                            ),

                          ],
                        ),
                      ),
                    ),
                    elevation: 20,
                  ).closed.then((value)
                  {
                    cubit.changeBottomSheetShown(
                      isShown: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.changeBottomSheetShown(
                    isShown: true,
                    icon: Icons.add,
                  );
                }
              },
              child:  Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index)
              {
                cubit.changeIndex(index);
              },
              items:
              const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'tasks',

                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle,
                  ),
                  label: 'done',

                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_rounded,
                  ),
                  label: 'archived',

                ),

              ],

            ),

          );
        },
      ),
    );
  }

}




