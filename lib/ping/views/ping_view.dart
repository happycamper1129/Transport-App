// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/models/animated_list_model.dart';
import 'package:network_arch/ping/ping.dart';
import 'package:network_arch/shared/action_app_bar.dart';
import 'package:network_arch/shared/cupertino_action_app_bar.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/utils/enums.dart';

class PingView extends StatefulWidget {
  const PingView({Key? key}) : super(key: key);

  @override
  _PingViewState createState() => _PingViewState();
}

class _PingViewState extends State<PingView> {
  final _listKey = GlobalKey<AnimatedListState>();
  final _targetHostController = TextEditingController();
  late final AnimatedListModel<PingData?> _pingData;

  late String _targetHost;

  String get _target => _targetHostController.text;

  @override
  void initState() {
    super.initState();

    _pingData = AnimatedListModel<PingData>(
      listKey: _listKey,
      removedItemBuilder: _buildItem,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final String routedAddr =
        // ignore: cast_nullable_to_non_nullable
        ModalRoute.of(context)!.settings.arguments as String;
    _targetHostController.text = routedAddr;
  }

  @override
  void dispose() {
    super.dispose();

    _targetHostController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return BlocBuilder<PingBloc, PingState>(
      builder: (context, state) {
        if (state is PingRunInProgress) {
          final repository = context.read<PingRepository>();

          repository.subscription = state.pingStream.listen((event) {
            log(event.toString());
            _pingData.insert(_pingData.length, event);
          });

          return Scaffold(
            appBar: ActionAppBar(
              context,
              title: 'Ping',
              action: ButtonActions.stop,
              isActive: _target.isNotEmpty,
              onPressed: _handleStop,
            ),
            body: SingleChildScrollView(
              child: _buildBody(context),
            ),
          );
        } else {
          return Scaffold(
            appBar: ActionAppBar(
              context,
              title: 'Ping',
              action: ButtonActions.start,
              isActive: _target.isNotEmpty,
              onPressed: _handleStart,
            ),
            body: SingleChildScrollView(
              child: _buildBody(context),
            ),
          );
        }
      },
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          BlocBuilder<PingBloc, PingState>(
            builder: (context, state) {
              if (state is PingRunInProgress) {
                return CupertinoActionAppBar(
                  context,
                  title: 'Ping',
                  action: ButtonActions.stop,
                  isActive: _target.isNotEmpty,
                  onPressed: _handleStop,
                );
              } else {
                return CupertinoActionAppBar(
                  context,
                  title: 'Ping',
                  action: ButtonActions.start,
                  isActive: _target.isNotEmpty,
                  onPressed: _handleStart,
                );
              }
            },
          )
        ],
        body: _buildBody(context),
      ),
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: BlocBuilder<PingBloc, PingState>(
                  builder: (context, state) {
                    return PlatformWidget(
                      androidBuilder: (context) => TextField(
                        autocorrect: false,
                        controller: _targetHostController,
                        enabled: state is! PingRunInProgress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'IP address (e.g. 1.1.1.1)',
                        ),
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                      iosBuilder: (context) => CupertinoSearchTextField(
                        autocorrect: false,
                        controller: _targetHostController,
                        enabled: state is! PingRunInProgress,
                        placeholder: 'IP address (e.g. 1.1.1.1)',
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              BlocBuilder<PingBloc, PingState>(
                builder: (context, state) {
                  if (state is PingRunComplete && _pingData.isNotEmpty) {
                    return TextButton(
                      onPressed: () => _pingData.removeAllElements(context),
                      child: const Text('Clear list'),
                    );
                  }

                  return const TextButton(
                    onPressed: null,
                    child: Text('Clear list'),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedList(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            key: _listKey,
            initialItemCount: _pingData.length,
            itemBuilder: (context, index, animation) {
              return _buildItem(
                context,
                animation,
                _pingData[index],
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    Animation<double> animation,
    PingData? item,
  ) {
    if (item!.error != null) {
      context.read<PingBloc>().add(PingStopped());

      return FadeTransition(
        opacity: animation.drive(_pingData.fadeTween),
        child: SlideTransition(
          position: animation.drive(_pingData.slideTween),
          child: PingCard(
            hasError: true,
            list: _pingData,
            item: item,
            addr: _targetHost,
          ),
        ),
      );
    }

    if (item.response != null) {
      return FadeTransition(
        opacity: animation.drive(_pingData.fadeTween),
        child: SlideTransition(
          position: animation.drive(_pingData.slideTween),
          child: PingCard(
            hasError: false,
            list: _pingData,
            item: item,
            addr: _targetHost,
          ),
        ),
      );
    } else {
      throw Exception('Unexpected item type');
    }
  }

  Future<void> _handleStart() async {
    await _pingData.removeAllElements(context);

    _targetHost = _target;
    context.read<PingBloc>().add(PingStarted(_target));
  }

  void _handleStop() {
    context.read<PingBloc>().add(PingStopped());
  }
}