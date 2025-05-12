import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';

part 'orderstatus_event.dart';
part 'orderstatus_state.dart';

class OrderstatusBloc extends Bloc<OrderstatusEvent, OrderstatusState> {
  final FirebaseFirestore firestore = serviceLocator<FirebaseFirestore>();
  StreamSubscription<DocumentSnapshot>? _subscription;
  OrderstatusBloc() : super(OrderstatusInitial()) {
    on<StartListeningOrderStatus>((event, emit) async {
      emit(OrderStatusLoading());
      _subscription?.cancel();
      _subscription = firestore
          .collection('orders')
          .doc(event.orderId)
          .snapshots()
          .listen((snapshot) {
        print("Order status snapshot: ${snapshot.data()}");
        if (snapshot.exists) {
          final data = snapshot.data();

          final status = data?['orderStatus'];
          final progress = data?['orderProgress'];
          if (status == 'denied') {
            add(OrderStatusUpdated('denied'));
          } else if (status == 'confirmed' && progress != null) {
            add(OrderProgressChanged(progress));
          } else {
            add(OrderStatusUpdated(status));
          }
        } else {
          emit(OrderStatusError(error: 'Order not found'));
        }
      });
    });
    on<OrderStatusUpdated>((event, emit) {
      print("Order status updated: ${event.status}");
      switch (event.status) {
        case 'pending':
          emit(OrderWaiting());
          break;
        case 'confirmed':
          emit(OrderConfirmed());
          break;
        case 'delivered':
          emit(OrderDelivered());
          break;
        case 'denied':
          emit(OrderDenied());
          break;
        case 'error':
          emit(OrderStatusError(error: 'Order not found'));
          break;
        default:
          emit(OrderWaiting());
      }
    });
    on<OrderProgressChanged>((event, emit) {
      print("Order progress updated: ${event.progress}");
      emit(OrderProgressUpdated(event.progress));
    });

    on<StopListeningOrderStatus>((event, emit) {
      _subscription?.cancel();
      emit(OrderstatusInitial());
    });
  }
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
