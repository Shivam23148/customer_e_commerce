part of 'orderstatus_bloc.dart';

abstract class OrderstatusEvent {}

class StartListeningOrderStatus extends OrderstatusEvent {
  final String orderId;

  StartListeningOrderStatus(this.orderId);
}

class OrderStatusUpdated extends OrderstatusEvent {
  final String status;

  OrderStatusUpdated(this.status);
}

class OrderProgressChanged extends OrderstatusEvent {
  final String progress;

  OrderProgressChanged(this.progress);
}

class StopListeningOrderStatus extends OrderstatusEvent {
  StopListeningOrderStatus();
}
