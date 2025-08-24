import 'package:flutter/material.dart';

// Remove this class if you already import it from your file.
class AcademicBuildingsCard extends StatelessWidget {
  final String shortName;
  final String fullName;
  final dynamic icon; // IconData or String path
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
      return const Icon(Icons.school, size: 24, color: Colors.black87);
    }
  }
}

class CspitDepartmentsScreen extends StatelessWidget {
  const CspitDepartmentsScreen({Key? key}) : super(key: key);

  // B.Tech Departments (from your image)
  List<_DeptItem> _btech(BuildContext context) => [
    _DeptItem(
      shortName: 'CSE',
      fullName: 'Computer Science & Engineering',
      icon: 'assets/CSE.png',
    ),
    _DeptItem(
      shortName: 'EC',
      fullName: 'Electronics & Communication Engineering',
      icon: 'assets/EC.png',
    ),
    _DeptItem(
      shortName: 'IT',
      fullName: 'Information Technology',
      icon: 'assets/IT.jpg',
    ),
    _DeptItem(
      shortName: 'Civil',
      fullName: 'Civil Engineering',
      icon: 'assets/Civil.jpg',
    ),
    _DeptItem(
      shortName: 'CE',
      fullName: 'Computer Engineering',
      icon: 'assets/CE.png',
    ),
    _DeptItem(
      shortName: 'ME',
      fullName: 'Mechanical Engineering',
      icon: 'assets/ME.jpg',
    ),
    _DeptItem(
      shortName: 'AIML',
      fullName: 'Artificial Intelligence and Machine Learning',
      icon: 'assets/AIML.png',
    ),
    _DeptItem(
      shortName: 'EE',
      fullName: 'Electrical Engineering',
      icon: 'assets/EE.png',
    ),
  ];

  // M.Tech Programs (from your image)
  List<_DeptItem> _mtech(BuildContext context) => [
    _DeptItem(
      shortName: 'AMT',
      fullName: 'Advanced Manufacturing Technology',
      icon: 'assets/AMT.jpeg',
    ),
    _DeptItem(
      shortName: 'CE',
      fullName: 'Computer Engineering',
      icon: 'assets/CE.png',
    ),
    _DeptItem(
      shortName: 'SE',
      fullName: 'Structural Engineering',
      icon: 'assets/SE.png',
    ),
    _DeptItem(
      shortName: 'Thermal',
      fullName: 'Thermal Engineering',
      icon: 'assets/TE.png',
    ),
    _DeptItem(shortName: 'PGDEAMT', fullName: 'PGDEAMT', icon: 'assets/PD.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final btech = _btech(context);
    final mtech = _mtech(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'CSPIT Programs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _SectionHeader(title: 'Under Graduate Programs (B. Tech)'),
          const SizedBox(height: 12),
          ..._cards(btech, context),
          const SizedBox(height: 24),
          _Divider(),
          const SizedBox(height: 16),
          _SectionHeader(title: 'Post Graduate Programs (M. Tech)'),
          const SizedBox(height: 12),
          ..._cards(mtech, context),
        ],
      ),
    );
  }

  List<Widget> _cards(List<_DeptItem> items, BuildContext context) {
    return List<Widget>.generate(items.length, (i) {
      final d = items[i];
      return Padding(
        padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 16),
        child: AcademicBuildingsCard(
          shortName: d.shortName,
          fullName: d.fullName,
          icon: d.icon,
          onTap: () => _onItemTap(context, d),
        ),
      );
    });
  }

  void _onItemTap(BuildContext context, _DeptItem d) {
    // Replace with navigation to department details or panorama
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${d.fullName} tapped')));
  }
}

class _DeptItem {
  final String shortName;
  final String fullName;
  final dynamic icon;

  _DeptItem({
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
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: Colors.grey.shade300);
  }
}
