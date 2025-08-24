import 'package:flutter/material.dart';

// If you already have this in a shared file, import it and delete this copy.
class AcademicBuildingsCard extends StatelessWidget {
  final String shortName;
  final String fullName;
  final dynamic icon; // IconData or String asset path
  final VoidCallback? onTap;

  const AcademicBuildingsCard({
    Key? key,
    required this.shortName,
    required this.fullName,
    required this.icon,
    this.onTap,
  }) : super(key: key);

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
        Icons.health_and_safety,
        size: 24,
        color: Colors.black87,
      );
    }
  }
}

class AripProgramsScreen extends StatelessWidget {
  const AripProgramsScreen({Key? key}) : super(key: key);

  // UG
  List<_Item> _bpt() => const [
    _Item(
      shortName: 'BPT',
      fullName: 'Bachelor of Physiotherapy (BPT)',
      icon: 'assets/physio.png',
    ),
  ];

  // PG specializations
  List<_Item> _mpt() => const [
    _Item(
      shortName: 'MPT-MS',
      fullName: 'Master of Physiotherapy (Musculoskeletal Science)',
      icon: 'assets/MS.png',
    ),
    _Item(
      shortName: 'MPT-NS',
      fullName: 'Master of Physiotherapy (Neurological Science)',
      icon: 'assets/NS.png',
    ),
    _Item(
      shortName: 'MPT-CPS',
      fullName: 'Master of Physiotherapy (Cardiopulmonary Science)',
      icon: 'assets/CPS.jpg',
    ),
    _Item(
      shortName: 'MPT-PED',
      fullName: 'Master of Physiotherapy (Paediatric)',
      icon: 'assets/PED.png',
    ),
    _Item(
      shortName: 'MPT-REH',
      fullName: 'Master of Physiotherapy (Rehabilitation)',
      icon: 'assets/REH.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ug = _bpt();
    final pg = _mpt();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'ARIP Programs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const _SectionHeader(title: 'Under Graduate Program'),
          const SizedBox(height: 12),
          ..._cards(ug, context),
          const SizedBox(height: 24),
          const _Divider(),
          const SizedBox(height: 16),
          const _SectionHeader(title: 'Post Graduate Programs (MPT)'),
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
    // Navigate to department details or brochure if needed
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
