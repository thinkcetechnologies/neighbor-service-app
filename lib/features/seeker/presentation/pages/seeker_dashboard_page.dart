import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/features/seeker/presentation/bloc/seeker_bloc.dart';
import 'package:nsapp/features/seeker/presentation/widgets/seeker_bottom_navigation_bar_widget.dart';

class SeekerDashboardPage extends StatefulWidget {
  const SeekerDashboardPage({super.key});

  @override
  State<SeekerDashboardPage> createState() => _SeekerDashboardPageState();
}

class _SeekerDashboardPageState extends State<SeekerDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeekerBloc, SeekerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body:PopScope(
            canPop: (SeekerVisitedPagesState.pages.isEmpty),
            onPopInvokedWithResult: (pop, oo){
              context.read<SeekerBloc>().add(SeekerBackPressedEvent());
            },
            child: NavigatorSeekerState.widget,
          ),
          bottomNavigationBar: SeekerBottomNavigationBarWidget(),
        );
      },
    );
  }
}
