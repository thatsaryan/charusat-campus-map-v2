import 'package:flutter/material.dart';
import 'package:charusat_maps/Institutes/CspitDepartmentsScreen.dart';
import 'package:charusat_maps/Institutes/DepstarProgramsScreen.dart';
import 'package:charusat_maps/Institutes/AripProgramsScreen.dart';
import 'package:charusat_maps/Institutes/BdipsProgramsScreen.dart';
import 'package:charusat_maps/Institutes/CmpicaProgramsScreen.dart';
import 'package:charusat_maps/Institutes/IiimProgramsScreen.dart';
import 'package:charusat_maps/Institutes/PdpiasProgramsScreen.dart';
import 'package:charusat_maps/Institutes/MtinProgramsScreen.dart';
import 'package:charusat_maps/Institutes/RpcpProgramsScreen.dart';

class AcademicBuildingsCard extends StatelessWidget {
  final String shortName;
  final String fullName;
  final dynamic icon;
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
                  borderRadius: BorderRadius.circular(
                    24.0,
                  ), // Fully rounded circle
                ),
                clipBehavior: Clip.hardEdge, // Clips child to rounded border
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
        fit: BoxFit.cover, // Changed to cover for better circular fill
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error_outline, size: 24, color: Colors.red);
        },
      );
    } else {
      return const Icon(Icons.help_outline, size: 24, color: Colors.black87);
    }
  }
}

class AcademicBuildingsCardOriginal extends StatelessWidget {
  final VoidCallback? onTap;

  const AcademicBuildingsCardOriginal({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AcademicBuildingsCard(
      shortName: 'Academic Buildings',
      fullName: 'Classrooms, labs, and\ndepartments',
      icon: Icons.school,
      onTap: onTap,
    );
  }
}

class AcademicBuildingsScreen extends StatelessWidget {
  const AcademicBuildingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Academic Buildings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AcademicBuildingsCard(
              shortName: 'ARIP',
              fullName: 'Adhoc & Rita Patel Institute of Physiotherapy',
              icon: 'assets/arip-logo.png',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AripProgramsScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            AcademicBuildingsCard(
              shortName: 'BDIPS',
              fullName:
                  'Bapubhai Desaibhai Patel Institute of Paramedical Sciences',
              icon: 'assets/bdips-logo.jpg',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const BdipsProgramsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            AcademicBuildingsCard(
              shortName: 'CMPICA',
              fullName:
                  'Smt. Chandaben Mohanbhai Patel Institute of Computer Applications',
              icon: 'assets/cmpica-logo.jpg',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CmpicaProgramsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            AcademicBuildingsCard(
              shortName: 'CSPIT',
              fullName: 'Chandubhai S. Patel Institute of Technology',
              icon: 'assets/cspit-logo.png',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CspitDepartmentsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            AcademicBuildingsCard(
              shortName: 'DEPSTAR',
              fullName:
                  'Devang Patel Institute of Advance Technology and Research',
              icon: 'assets/depstar-logo.jpg',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const DepstarProgramsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            AcademicBuildingsCard(
              shortName: 'IIIM',
              fullName: 'Indukaka Ipcowala Institute of Management',
              icon: 'assets/i2im-logo.jpg',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const IiimProgramsScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            AcademicBuildingsCard(
              shortName: 'MTIN',
              fullName: 'Manikaka Topawala Institute of Nursing',
              icon: 'assets/mtin-logo.jpg',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MtinProgramsScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            AcademicBuildingsCard(
              shortName: 'PDPIAS',
              fullName: 'P. D. Patel Institute of Applied Sciences',
              icon: 'assets/pdpis-logo.jpg',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PdpiasProgramsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            AcademicBuildingsCard(
              shortName: 'RPCP',
              fullName: 'Ramanbhai Patel College of Pharmacy',
              icon: 'assets/rpcp-logo.jpg',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RpcpProgramsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
