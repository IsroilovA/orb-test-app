import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helm/helm.dart';
import 'package:orb_test_app/src/app/root_scope.dart';
import 'package:orb_test_app/src/core/localization/l10n.dart';
import 'package:orb_test_app/src/core/routing/orb_routes.dart';
import 'package:orb_test_app/src/features/home/bloc/home_bloc.dart';
import 'package:orb_test_app/src/features/home/common/model/home_error.dart';
import 'package:orb_test_app/src/features/home/widget/home_businesses_section.dart';
import 'package:orb_test_app/src/features/home/widget/home_user_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) =>
          HomeBloc(homeRepository: RootScope.of(context).homeRepository)..add(const HomeStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.homeTitle),
          actions: <Widget>[
            IconButton(
              tooltip: context.l10n.homeSettingsTooltip,
              onPressed: () => HelmRouter.push(context, OrbRoutes.settings),
              icon: const Icon(Icons.settings_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.isLoading && state.overview == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.error != null && state.overview == null) {
                final error = state.error;
                final message = switch (error) {
                  HomeError() => error.localize(context.l10n),
                  _ => context.l10n.homeLoadError,
                };

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(message, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => context.read<HomeBloc>().add(const HomeRetried()),
                          child: Text(context.l10n.homeRetryCta),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final overview = state.overview;
              if (overview == null) {
                return const SizedBox.shrink();
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  HomeUserSection(user: overview.user, businesses: overview.businesses),
                  const SizedBox(height: 28),
                  HomeBusinessesSection(businesses: overview.businesses),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
