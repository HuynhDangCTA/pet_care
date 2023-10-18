

abstract class AppState {

}

class StateSuccess extends AppState{
  dynamic result;

  StateSuccess({this.result});
}

class StateError extends AppState {
  String message;

  StateError(this.message);
}

class StateLoading extends AppState {

}

class StateEmptyData extends AppState{

}