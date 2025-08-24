import 'package:flutter/material.dart';

// If this card is already defined globally, import it and remove this copy.
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
      return const Icon(Icons.local_pharmacy, size: 24, color: Colors.black87);
    }
  }
}

class RpcpProgramsScreen extends StatelessWidget {
  const RpcpProgramsScreen({super.key});

  // UG
  List<_Item> _ug() => const [
    _Item(
      shortName: 'B.Pharm',
      fullName: 'Bachelor of Pharmacy',
      icon: 'assets/rpcp/bpharm.png',
    ),
  ];

  // PG (M.Pharm specializations)
  List<_Item> _pg() => const [
    _Item(
      shortName: 'M.Pharm (Pharm Tech)',
      fullName: 'Master of Pharmacy (Pharmaceutical Technology)',
      icon: 'assets/rpcp/mpharm_pharmtech.png',
    ),
    _Item(
      shortName: 'M.Pharm (Pharmacology)',
      fullName: 'Master of Pharmacy (Pharmacology)',
      icon: 'assets/rpcp/mpharm_pharmacology.png',
    ),
    _Item(
      shortName: 'M.Pharm (QA)',
      fullName: 'Master of Pharmacy (Pharmaceutical Quality Assurance)',
      icon: 'assets/rpcp/mpharm_qa.png',
    ),
    _Item(
      shortName: 'M.Pharm (Practice)',
      fullName: 'Master of Pharmacy (Pharmacy Practice)',
      icon: 'assets/rpcp/mpharm_practice.png',
    ),
    _Item(
      shortName: 'M.Pharm (Reg Affairs)',
      fullName: 'Master of Pharmacy (Regulatory Affairs)',
      icon: 'assets/rpcp/mpharm_reg.png',
    ),
    _Item(
      shortName: 'M.Pharm (Pharm Chem)',
      fullName: 'Master of Pharmacy (Pharmaceutical Chemistry)',
      icon: 'assets/rpcp/mpharm_chem.png',
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
          'RPCP Programs',
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
  // ignore: use_super_parameters
  const _Divider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: Colors.grey.shade300);
  }
}
