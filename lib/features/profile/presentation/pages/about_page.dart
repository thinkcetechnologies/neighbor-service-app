import 'package:flutter/material.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/features/profile/presentation/wdgets/portfolio_widget.dart';
import 'package:nsapp/features/profile/presentation/wdgets/reviews_widget.dart';


class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {

    controller = TabController(length: 2, vsync: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(),
            child: TabBar(
              controller: controller,
              physics: BouncingScrollPhysics(),
              tabs: [
                Tab(text: "PORTFOLIO", icon: Icon(Icons.description)),
                Tab(text: "REVIEWS", icon: Icon(Icons.reviews)),
              ],
            ),
          ),
          SizedBox(
            height: size(context).height - 240,
            width: size(context).width,
            child: TabBarView(
              controller: controller,
              children: [PortfolioWidget(), ReviewsWidget()],
            ),
          ),
        ],
      ),
    );
  }
}
