import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/constant/componants.dart';
import 'package:to_do/cubits/states.dart';

import '../cubits/cubit.dart';

class DoneTask extends StatelessWidget {
  const DoneTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder : (context, state)
      {
        var tasks=AppCubit.get(context).doneTasks;

        return taskBuilder(
          tasks: tasks,
        );
      },
    );
  }
}
