import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nft_creation/constants.dart';
import 'package:nft_creation/screens/game_screen.dart';
import 'package:nft_creation/screens/settings_screen.dart';
import 'package:nft_creation/screens/welcome_screen.dart';
import 'package:nft_creation/storage/upload_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../auth/auth_bloc_bloc.dart';
import 'package:nft_creation/widgets/category_cubit.dart';
import 'package:nft_creation/widgets/item_selector.dart';

class NFTScreen extends StatelessWidget {
  const NFTScreen({super.key});
  static const String id = 'nft_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryCubit>(
        create: (_) => CategoryCubit(), child: const NFTView());
  }
}

class NFTView extends StatelessWidget {
  const NFTView({super.key});
  static const List<String> categories = ["Eye", "Head", "Mouth"];

  @override
  Widget build(BuildContext context) {
    final user =
        (context.watch<AuthBlocBloc>().state as AuthStateAuthenticated).user;

    final selectedCategory =
        context.select((CategoryCubit c) => c.state.selectedCategory);
    final selectedEyeLayer =
        context.select((CategoryCubit c) => c.state.selectedEyeLayer);
    final selectedHeadLayer =
        context.select((CategoryCubit c) => c.state.selectedHeadLayer);
    final selectedMouthLayer =
        context.select((CategoryCubit c) => c.state.selectedMouthLayer);

    final selectedHead =
        context.select((CategoryCubit c) => c.state.selectedHead);
    final selectedEye =
        context.select((CategoryCubit c) => c.state.selectedEye);
    final selectedMouth =
        context.select((CategoryCubit c) => c.state.selectedMouth);

    return BlocListener<AuthBlocBloc, AuthBlocState>(
      listener: (context, state) {
        // if (state is! AuthStateAuthenticated) {
        if (state is AuthStateUnauthenticated) {
          // Pop route, we should not b here
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (() async {
            final controller = ScreenshotController();
            final bytes = await controller.captureFromWidget(buildStack(
                selectedHead: selectedHead,
                selectedEye: selectedEye,
                selectedMouth: selectedMouth));
            final appStorage = await getApplicationDocumentsDirectory();
            final file = File('${appStorage.path}/${user.email}.png');
            //final file = File('/Users/juliangottfried/Desktop/image.png');
            file.writeAsBytes(bytes);
            UploadFile().upload(file, user);
            Navigator.pushNamed(context, GameScreen.id);
          }),
          backgroundColor: kDefaultBackgroundColor,
          child: const Icon(Icons.arrow_forward_ios),
        ),
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: kDefaultColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                padding: const EdgeInsets.all(5),
                child: Text(
                  "${user.displayName}",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 17.0),
              child: user.photoURL != null
                  ? CircleAvatar(
                      backgroundImage: Image.network(user.photoURL!).image,
                    )
                  : CircleAvatar(
                      radius: 15,
                      backgroundColor: kDefaultColor,
                      child: const Text("J"),
                    ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => context.read<AuthBlocBloc>().logOut(),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, SettingsScreen.id);
                },
              ),
            ]),
        backgroundColor: kDefaultBackgroundColor,
        // Slivers
        body: Column(
          children: [
            // 3 elements combined
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 300,
                child: buildStack(
                    selectedHead: selectedHead,
                    selectedEye: selectedEye,
                    selectedMouth: selectedMouth),
              ),
            ),
            // selector eye/head mouth
            Expanded(
              flex: 1,
              child: Container(
                color: kDefaultColor,
                height: 25,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) =>
                      buildCategory(index, selectedCategory),
                ),
              ),
            ),
            // grids for each category
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.only(left: 15),
                color: kDefaultColor,
                height: 25,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  scrollDirection: Axis.horizontal,

                  // TRY TODO: TabBarView(children: ),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    int imageNr = index + 1;
                    if (selectedCategory == 0) {
                      String img = "assets/images/eye$imageNr.png";
                      return InkWell(
                        onTap: () => context
                            .read<CategoryCubit>()
                            .updateCategory(
                                selectedEye: img, selectedEyeLayer: index),
                        child: ItemSelector(
                          isSelected: selectedEyeLayer == index,
                          img: img,
                        ),
                      );
                    } else if (selectedCategory == 1) {
                      String img = "assets/images/head$imageNr.png";
                      return InkWell(
                        onTap: () => context
                            .read<CategoryCubit>()
                            .updateCategory(
                                selectedHead: img, selectedHeadLayer: index),
                        child: ItemSelector(
                          isSelected: selectedHeadLayer == index,
                          img: img,
                        ),
                      );
                    } else if (selectedCategory == 2) {
                      String img = "assets/images/mouth$imageNr.png";
                      return InkWell(
                        onTap: () => context
                            .read<CategoryCubit>()
                            .updateCategory(
                                selectedMouth: img, selectedMouthLayer: index),
                        child: ItemSelector(
                          isSelected: selectedMouthLayer == index,
                          img: img,
                        ),
                      );
                    } else {
                      return const Text("Data Loading Error");
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategory(int index, int selectedCategory) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () => context
            .read<CategoryCubit>()
            .updateCategory(selectedCategory: index),
        child: Padding(
          padding: const EdgeInsets.only(top: 25, left: 55),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                categories[index],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        selectedCategory == index ? Colors.white : Colors.grey,
                    fontSize: 22),
              ),
              if (selectedCategory == index)
                Container(
                  margin: const EdgeInsets.only(top: 20 / 4),
                  height: 2,
                  width: 30,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      );
    });
  }
}

class buildStack extends StatelessWidget {
  const buildStack({
    Key? key,
    required this.selectedHead,
    required this.selectedEye,
    required this.selectedMouth,
  }) : super(key: key);

  final String selectedHead;
  final String selectedEye;
  final String selectedMouth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(selectedHead),
        Image.asset(selectedEye),
        Image.asset(selectedMouth),
      ],
    );
  }
}
