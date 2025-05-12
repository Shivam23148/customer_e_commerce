part of 'orderstatus_bloc.dart';

abstract class OrderstatusState {}

class OrderstatusInitial extends OrderstatusState {}

class OrderStatusLoading extends OrderstatusState {}

class OrderWaiting extends OrderstatusState {}

class OrderConfirmed extends OrderstatusState {}

class OrderDelivered extends OrderstatusState {}

class OrderDenied extends OrderstatusState {}

class OrderProgressUpdated extends OrderstatusState {
  final String progress;
  OrderProgressUpdated(this.progress);
}

class OrderStatusError extends OrderstatusState {
  final String error;
  OrderStatusError({required this.error});
}
