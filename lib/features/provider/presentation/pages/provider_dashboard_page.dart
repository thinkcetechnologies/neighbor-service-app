import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsapp/features/provider/presentation/widgets/provider_button_navigation_bar_widget.dart';

import '../bloc/provider_bloc.dart';

class ProviderDashboardPage extends StatefulWidget {
  const ProviderDashboardPage({super.key});

  @override
  State<ProviderDashboardPage> createState() => _ProviderDashboardPageState();
}

class _ProviderDashboardPageState extends State<ProviderDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProviderBloc, ProviderState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: PopScope(
            canPop: (ProviderVisitedPagesState.pages.isEmpty),
            onPopInvokedWithResult: (pop, os) {
              context.read<ProviderBloc>().add(ProviderBackPressedEvent());
            },
            child: NavigatorProviderState.widget,
          ),
          bottomNavigationBar: ProviderButtonNavigationBarWidget(),
        );
      },
    );
  }
}
