import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  String? lastvisitedRoute;
  ConnectivityBloc(this._connectivity) : super(ConnectivityInitial()) {
    on<CheckConnectivityEvent>((event, emit) async {
      final result = await _connectivity.checkConnectivity();
      add(ConnectivityChangedEvent(result.first));
    });
    on<ConnectivityChangedEvent>((event, emit) {
      if (event.connectivityResult == ConnectivityResult.none) {
        emit(ConnectivityDisconnected());
      } else {
        emit(ConnectivityConnected());
      }
    });
    _connectivity.onConnectivityChanged.listen((results) {
      add(ConnectivityChangedEvent(results.first));
      print("Connectivity bloc connection result ${results}");
    });
  }
}
