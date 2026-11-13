import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laoblogger/core/styles/colors/app_colors.dart';
import 'package:laoblogger/feature/home/cubit/home_cubit.dart';
import 'package:laoblogger/feature/home/cubit/home_state.dart';

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Investing",
          style: TextStyle(color: AppColors.primaryColor),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.homeModel.length,
                  itemBuilder: (context, index) {
                    final stock = state.homeModel[index];
                    return ListTile(
                      leading: Image.asset(
                        stock.logoPath,
                        width: 32,
                        height: 32,
                      ),
                      title: Text(stock.symbol),
                      subtitle: Text(stock.name),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(stock.price),
                          Text(
                            stock.change,
                            style: TextStyle(
                              color: stock.isPositive
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
