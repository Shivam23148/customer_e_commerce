part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent {}

class CheckConnectivityEvent extends ConnectivityEvent {}

class ConnectivityChangedEvent extends ConnectivityEvent {
  final ConnectivityResult connectivityResult;

  ConnectivityChangedEvent(this.connectivityResult);
}
