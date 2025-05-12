import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/toast_util.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/OrderStatus/orderstatus_bloc.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  //Define the steps for the order tracking process
  final List<EasyStep> _steps = [
    const EasyStep(
        icon: Icon(Icons.pending),
        title: 'Pending',
        finishIcon: Icon(
          Icons.pending,
          color: AppColors.textSecondary,
        )),
    const EasyStep(
        icon: Icon(Icons.check_circle_outline),
        title: 'Confirmed',
        finishIcon: Icon(
          Icons.pending,
          color: AppColors.successColor,
        )),
    const EasyStep(
        icon: Icon(
          Icons.local_shipping_outlined,
        ),
        title: 'Shipped',
        finishIcon: Icon(
          Icons.local_shipping_outlined,
          color: Colors.blue,
        )),
    const EasyStep(
      icon: Icon(Icons.home_outlined),
      title: 'Delivered',
      finishIcon: Icon(
        Icons.home_outlined,
        color: AppColors.successColor,
      ),
    ),
  ];
  int _activeStep = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderstatusBloc()..add(StartListeningOrderStatus(widget.orderId)),
      child: PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.background,
            ),
            body: BlocListener<OrderstatusBloc, OrderstatusState>(
              listener: (context, state) {
                print("Order waiting state $state");
                if (state is OrderConfirmed) {
                  print("Order confirmed state: $state");
                  ToastUtil.showToast(
                      "Order confirmed", AppColors.successColor);
                  _activeStep = 1;
                } else if (state is OrderDelivered) {
                  ToastUtil.showToast(
                      "Order Delivered Successfully", AppColors.successColor);

                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      GoRouter.of(context).pop();
                    }
                  });
                } else if (state is OrderDenied) {
                  print("Order Denied state: $state");
                  ToastUtil.showToast("Order Denied", AppColors.primary);

                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      GoRouter.of(context).pop();
                    }
                  });
                }
                if (state is OrderProgressUpdated) {
                  switch (state.progress) {
                    case 'shipped':
                      _activeStep = 2;
                      break;
                    case 'out_for_delivery':
                      _activeStep = 3;
                      break;

                    case 'delivered':
                      _activeStep = 4;
                      break;
                  }
                }
                setState(() {});
              },
              child: BlocBuilder<OrderstatusBloc, OrderstatusState>(
                  builder: (context, state) {
                print("Order waiting state: $state");
                Widget content;
                if (state is OrderStatusLoading) {
                  content = Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                } else if (state is OrderWaiting) {
                  _activeStep = 0;
                  content = Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text("Waiting for the owner to confirm your order..."),
                      ],
                    ),
                  );
                } else if (state is OrderConfirmed) {
                  _activeStep = 1;
                  content = const Center(child: Text("Order Confirmed"));
                } else if (state is OrderDenied) {
                  _activeStep = 4;
                  content = const Center(child: Text("Order Denied"));
                } else if (state is OrderProgressUpdated) {
                  content = Center(
                      child: Text("Order progress updated ${state.progress}"));
                } else if (state is OrderStatusError) {
                  content = Center(child: Text("Error: ${state.error}"));
                } else {
                  content = const SizedBox.shrink();
                }
                return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        EasyStepper(
                          activeStep: _activeStep,
                          alignment: Alignment.center,
                          steps: _steps,
                          stepRadius: 10,
                          borderThickness: 2,
                          direction: Axis.horizontal,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          showStepBorder: true,
                          showTitle: true,
                          stepShape: StepShape.circle,
                          fitWidth: false, // similar to `fit: FlexFit.loose`
                          stepAnimationDuration: Duration(milliseconds: 300),
                          activeStepBackgroundColor: Colors.white,
                          activeStepTextColor: Colors.green,
                          activeStepIconColor: Colors.green,
                          unreachedStepBackgroundColor: Colors.grey,
                          unreachedStepTextColor: Colors.grey,
                          unreachedStepIconColor: Colors.grey,
                          finishedStepBackgroundColor: Colors.green,
                          finishedStepIconColor: Colors.white,
                          finishedStepTextColor: Colors.white,
                          finishedStepBorderColor: Colors.green,
                        ),
                        const SizedBox(height: 20),
                        Expanded(child: Center(child: content)),
                      ],
                    ));
              }),
            ),
          )),
    );
  }
}
