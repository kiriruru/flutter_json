import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../cubit/chosen_cubit.dart';
import '../classes/DataSource.dart';

class ConfigInputsWidget extends StatelessWidget {
  final dataSource = Modular.get<DataSource>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChosenUserCubit, ChosenUserCubitState>(
      builder: (context, state) {
        if (state is ChosenUserCubitStateInit) {
          print("state init");
          return Center(
            child: Row(
              children: [
                Icon(Icons.arrow_back),
                Text("Select user"),
              ],
            ),
          );
        } else if (state is ChosenUserCubitStateLoading) {
          print("state is loading");
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChosenUserCubitStateReady) {
          print("state is ready");
          return SingleChildScrollView(
            child: Column(
                children: dataSource.config.values
                    .map((value) => InputWidget(
                          initValue: state.data[value["title"]] ?? "",
                          config: value,
                          onStopEditing: dataSource.updateData,
                        ))
                    .toList()),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
// {
// if (state == null || state == "") {
//   return Center(
//     child: Row(
//       children: [
//         Icon(Icons.arrow_back),
//         Text("Select user"),
//       ],
//     ),
//   );
// } else {
//   return FutureBuilder(
//     future: readJsonData(state),
//     builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//       if (snapshot.hasData) {
//         return SingleChildScrollView(
//           child: Column(
//               children: dataSource.config.values
//                   .map((value) => InputWidget(
//                         initValue:
//                             dataSource.jsonItem[value["title"]] ?? "",
//                         config: value,
//                         onStopEditing: dataSource.updateData,
//                       ))
//                   .toList()),
//         );
//       } else if (snapshot.hasError) {
//         return const Text("Something went wrong");
//       } else {
//         return const Center(child: CircularProgressIndicator());
//       }
//     },
//   );
// }

class InputWidget extends StatelessWidget {
  final String initValue; // from parent widget
  final Map<String, String> config; // from parent widget
  final Function onStopEditing; // from parent widget
  final TextEditingController _controller = TextEditingController();

  InputWidget({
    super.key,
    required this.initValue,
    required this.config,
    required this.onStopEditing,
  }) {
    _controller.text = initValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ChosenUserCubit>(context);
    return Focus(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: config["title"],
            hintText: config["hint"],
          ),
          controller: _controller,
        ),
        onFocusChange: (hasFocus) {
          if (hasFocus) return;
          onStopEditing(config["title"], _controller.text, cubit.state);
        });
  }
}
