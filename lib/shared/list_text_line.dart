// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/shared/list_circular_progress_indicator.dart';

class ListTextLine extends StatelessWidget {
  const ListTextLine({
    required this.textL,
    this.textR,
    this.onRefreshTap,
    Key? key,
  }) : super(key: key);

  final Text textL;
  final Text? textR;
  final VoidCallback? onRefreshTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return textR != null
            ? constraints.maxWidth < 200 || textR!.data!.length > 40
                ? Column(
                    children: [
                      Row(children: [textL, const Spacer()]),
                      const SizedBox(height: 5.0),
                      Row(
                        children: [
                          const Spacer(),
                          if (onRefreshTap != null)
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.only(right: 4),
                              splashRadius: 12.0,
                              iconSize: 16.0,
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.blue,
                              ),
                              onPressed: onRefreshTap,
                            ),
                          textR!,
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      textL,
                      const Spacer(),
                      if (onRefreshTap != null)
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.only(right: 4),
                          splashRadius: 12.0,
                          iconSize: 16.0,
                          icon: const Icon(Icons.refresh, color: Colors.blue),
                          onPressed: onRefreshTap,
                        ),
                      textR!,
                    ],
                  )
            : Row(
                children: [
                  textL,
                  const Spacer(),
                  const ListCircularProgressIndicator(),
                ],
              );
      },
    );
  }
}
