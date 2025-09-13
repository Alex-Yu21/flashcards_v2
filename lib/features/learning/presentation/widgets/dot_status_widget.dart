import 'package:flutter/material.dart';

const _kStats = <_StatConfig>[
  _StatConfig(
    label: 'New Words',
    color: Colors.black,
    // AppColors.tertiary70
    value: 12,
    delta: 0,
  ),
  _StatConfig(
    label: 'Learning',
    color: Colors.black,
    // AppColors.tertiary60
    value: 34,
    delta: 5,
  ),
  _StatConfig(
    label: 'Reviewing',
    color: Colors.black,
    // AppColors.tertiary50
    value: 18,
    delta: -2,
  ),
  _StatConfig(
    label: 'Mastered',
    color: Colors.black,
    // AppColors.tertiary40
    value: 7,
    delta: 0,
  ),
];

class DotStatusWidget extends StatelessWidget {
  const DotStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _kStats
            .map((cfg) => Expanded(child: _StatItem(cfg: cfg)))
            .toList(growable: false),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.cfg});

  final _StatConfig cfg;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle()
    // context.bodyStyle.copyWith(fontWeight: FontWeight.w300)
    ;
    final caption = TextStyle()
    // context.captionStyle.copyWith(color: Colors.grey)
    ;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 12, color: cfg.color),
        const SizedBox(height: 4),
        Text(cfg.label, style: caption),
        const SizedBox(height: 8),
        cfg.delta == 0
            ? Text('${cfg.value}', style: textStyle)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${cfg.value}', style: textStyle),
                  const SizedBox(width: 2),
                  Text(
                    cfg.delta > 0 ? '+${cfg.delta}' : '${cfg.delta}',
                    style: caption.copyWith(
                      color: cfg.delta > 0
                          ? const Color.fromARGB(255, 98, 156, 33)
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

class _StatConfig {
  final String label;
  final Color color;
  final int value;
  final int delta;
  const _StatConfig({
    required this.label,
    required this.color,
    required this.value,
    required this.delta,
  });
}
