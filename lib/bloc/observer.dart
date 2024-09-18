/*
 * *
 *  * observer.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 18:39
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/18/2024, 18:39
 *
 */

import 'package:astronacci/common/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Observer extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLog.print("$bloc $event");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    AppLog.print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    AppLog.print("$bloc $error");
    AppLog.print(stackTrace.toString());
    super.onError(bloc, error, stackTrace);
  }
}
