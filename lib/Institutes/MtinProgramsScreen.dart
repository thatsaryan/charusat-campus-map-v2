import 'package:flutter/material.dart';

// If you already have this globally, import it and remove this copy.
class AcademicBuildingsCard extends StatelessWidget {
  final String shortName;
  final String fullName;
  final dynamic icon; // IconData or String asset path
  final VoidCallback? onTap;

  const AcademicBuildingsCard({
    super.key,
    required this.shortName,
    required this.fullName,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16.0),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                clipBehavior: Clip.hardEdge,
                child: Center(child: _buildIcon()),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      shortName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fullName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon is IconData) {
      return Icon(icon as IconData, size: 24, color: Colors.black87);
    } else if (icon is String) {
      return Image.asset(
        icon as String,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error_outline, size: 24, color: Colors.red);
        },
      );
    } else {
      return const Icon(
        Icons.volunteer_activism,
        size: 24,
        color: Colors.black87,
      );
    }
  }
}

/// New screen: mtin_programs_screen.dart
class MtinProgramsScreen extends StatelessWidget {
  const MtinProgramsScreen({super.key});

  // UG programs
  List<_Item> _ug() => const [
    _Item(
      shortName: 'B.Sc Nursing',
      fullName: 'Bachelor of Science (Nursing)',
      icon: 'assets/mtin/bsc_nursing.png',
    ),
    _Item(
      shortName: 'GNM',
      fullName: 'General Nursing Midwifery (GNM)',
      icon: 'assets/mtin/gnm.png',
    ),
    _Item(
      shortName: 'PB B.Sc',
      fullName: 'Post Basic B.Sc. Nursing Program',
      icon: 'assets/mtin/pb_bsc.png',
    ),
  ];

  // PG programs (M.Sc Nursing specializations)
  List<_Item> _pg() => const [
    _Item(
      shortName: 'M.Sc Nursing (CH)',
      fullName: 'Master of Science Nursing (Community Health)',
      icon: 'assets/mtin/msc_ch.png',
    ),
    _Item(
      shortName: 'M.Sc Nursing (MH)',
      fullName: 'Master of Science Nursing (Mental Health)',
      icon: 'assets/mtin/msc_mh.png',
    ),
    _Item(
      shortName: 'M.Sc Nursing (OBG)',
      fullName: 'Master of Science Nursing (Obstetrics & Gynecology)',
      icon: 'assets/mtin/msc_obg.png',
    ),
    _Item(
      shortName: 'M.Sc Nursing (Child)',
      fullName: 'Master of Science Nursing (Child Health)',
      icon: 'assets/mtin/msc_child.png',
    ),
    _Item(
      shortName: 'M.Sc Nursing (MS)',
      fullName: 'Master of Science Nursing (Medical Surgical)',
      icon: 'assets/mtin/msc_ms.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ug = _ug();
    final pg = _pg();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'MTIN Programs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const _SectionHeader(title: 'Under Graduate Programs'),
          const SizedBox(height: 12),
          ..._cards(ug, context),
          const SizedBox(height: 24),
          const _Divider(),
          const SizedBox(height: 16),
          const _SectionHeader(title: 'Post Graduate Programs'),
          const SizedBox(height: 12),
          ..._cards(pg, context),
        ],
      ),
    );
  }

  List<Widget> _cards(List<_Item> items, BuildContext context) {
    return List<Widget>.generate(items.length, (i) {
      final d = items[i];
      return Padding(
        padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 16),
        child: AcademicBuildingsCard(
          shortName: d.shortName,
          fullName: d.fullName,
          icon: d.icon,
          onTap: () => _onTap(context, d),
        ),
      );
    });
  }

  void _onTap(BuildContext context, _Item d) {
    // Replace with navigation to details/brochure as needed
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${d.fullName} tapped')));
  }
}

class _Item {
  final String shortName;
  final String fullName;
  final dynamic icon;
  const _Item({
    required this.shortName,
    required this.fullName,
    required this.icon,
  });
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: Colors.grey.shade300);
  }
}
