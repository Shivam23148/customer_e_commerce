import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Address/address_bloc.dart';
import 'package:customer_e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddresslistScreen extends StatefulWidget {
  const AddresslistScreen({super.key});

  @override
  State<AddresslistScreen> createState() => _AddresslistScreenState();
}

class _AddresslistScreenState extends State<AddresslistScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressBloc()..add(FetchAddressListEvent()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text("Addresses"),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
        ),
        body: BlocBuilder<AddressBloc, AddressState>(
          buildWhen: (previous, current) {
            return current is AddressListLoadedState ||
                current is AddressListLoadingState;
          },
          builder: (context, state) {
            print("State of Address Bloc in Address List Screen is : ${state}");
            if (state is AddressListLoadedState) {
              return RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.background,
                onRefresh: () async {
                  context.read<AddressBloc>().add(FetchAddressListEvent());
                },
                child: state.addressList.isEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(child: Text("No addresses found")),
                      )
                    : ListView.builder(
                        itemCount: state.addressList.length,
                        itemBuilder: (context, index) {
                          final address = state.addressList[index];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: getRelativeWidth(0.02)),
                            leading: Icon(Icons.location_on_outlined),
                            title: Text(
                              address.addressType!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: SizedBox(
                              width: getRelativeWidth(0.3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      final bloc = context.read<AddressBloc>();
                                      GoRouter.of(context).push(
                                          MyRoutes.editAddessRoute,
                                          extra: {
                                            'address': address,
                                            'bloc': bloc
                                          });
                                    },
                                    icon:
                                        Icon(Icons.mode_edit_outline_outlined),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showdialogAlert(context);
                                    },
                                    icon: Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Text(
                              address.formattedAddress,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
              );
            }
            if (state is AddressListLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<dynamic> showdialogAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: AppColors.background,
              title: Text('Delete Address'),
              content: Text('Are you sure you want to delete this address?'),
              actions: [
                TextButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(color: AppColors.primary),
                    ))
              ],
            ));
  }
}
