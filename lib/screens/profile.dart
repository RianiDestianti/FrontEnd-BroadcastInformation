import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../layouts/layout.dart';
import 'login.dart';
import '../models/model.dart';
import '../constants/constant.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? _userProfile;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final nama = prefs.getString('nama') ?? 'User';
      final userType = prefs.getString('user_type') ?? 'Unknown';
      final username = prefs.getString('username') ?? '';
      final profileId = prefs.getInt('profile_id') ?? 0;
      final email =
          username.isNotEmpty
              ? '$username@smkn11bdg.sch.id'
              : 'user@smkn11bdg.sch.id';

      String department = '';
      String role = '';
      String studentId = '';

      if (userType.toLowerCase() == 'siswa') {
        department = 'Rekayasa Perangkat Lunak';
        role = 'Siswa';
        studentId = profileId.toString();
      } else if (userType.toLowerCase() == 'guru') {
        department = 'Pengajar';
        role = 'Guru';
        studentId = profileId.toString();
      } else {
        department = 'SMKN 11 Bandung';
        role = userType;
        studentId = username;
      }

      setState(() {
        _userProfile = UserProfile(
          name: nama,
          studentId: studentId,
          role: role,
          email: email,
          department: department,
        );
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user profile: $e');
      setState(() {
        _userProfile = const UserProfile(
          name: 'User',
          studentId: 'Unknown',
          role: 'Unknown',
          email: 'user@smkn11bdg.sch.id',
          department: 'SMKN 11 Bandung',
        );
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MainLayout(
        selectedIndex: 2,
        child: Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppThemeProfile.primaryColor,
            ),
          ),
        ),
      );
    }

    return MainLayout(
      selectedIndex: 2,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(userProfile: _userProfile!),
                const SizedBox(height: 24),
                PersonalInformationCard(userProfile: _userProfile!),
                const SizedBox(height: 24),
                const ActionButtonsSection(),
                const SizedBox(height: 40),
                const AppFooter(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.userProfile});
  final UserProfile userProfile;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppThemeProfile.primaryColor.withOpacity(0.4), Colors.white],
        ),
      ),
      child: Column(
        children: [
          const HeaderNavigation(),
          const SizedBox(height: 40),
          ProfileAvatar(userProfile: userProfile),
          const SizedBox(height: AppTheme.defaultSpacing),
          ProfileName(name: userProfile.name),
          DepartmentBadge(department: userProfile.department),
        ],
      ),
    );
  }
}

class HeaderNavigation extends StatelessWidget {
  const HeaderNavigation({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.defaultSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Container(), Container()],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.userProfile});
  final UserProfile userProfile;
  @override
  Widget build(BuildContext context) {
    String initials = _getInitials(userProfile.name);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: ProfileStyles.avatarRadius,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: ProfileStyles.innerAvatarRadius,
          backgroundColor: AppThemeProfile.primaryColor.withOpacity(0.2),
          child: Text(
            initials,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppThemeProfile.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    List<String> nameParts = name.split(' ');
    if (nameParts.length == 1) {
      return nameParts[0].substring(0, 1).toUpperCase();
    } else {
      return (nameParts[0].substring(0, 1) + nameParts[1].substring(0, 1))
          .toUpperCase();
    }
  }
}

class ProfileName extends StatelessWidget {
  const ProfileName({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return Text(name, style: ProfileStyles.nameStyle);
  }
}

class DepartmentBadge extends StatelessWidget {
  const DepartmentBadge({super.key, required this.department});
  final String department;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppThemeProfile.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.school,
            size: 16,
            color: AppThemeProfile.primaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            department,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppThemeProfile.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class PersonalInformationCard extends StatelessWidget {
  const PersonalInformationCard({super.key, required this.userProfile});
  final UserProfile userProfile;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppThemeProfile.horizontalPadding,
      ),
      child: CardContainer(
        child: Padding(
          padding: const EdgeInsets.all(ProfileStyles.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'Informasi Pribadi',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 8),
              const Divider(thickness: 1),
              const SizedBox(height: 8),
              InfoRow(
                label: 'Nama Lengkap',
                value: userProfile.name,
                icon: Icons.badge_outlined,
              ),
              InfoRow(
                label: userProfile.role == 'Siswa' ? 'NIS' : 'NIP',
                value: userProfile.studentId,
                icon: Icons.credit_card,
              ),
              InfoRow(
                label: 'Role',
                value: userProfile.role,
                icon: Icons.school_outlined,
              ),
              InfoRow(
                label: 'Jurusan/Bagian',
                value: userProfile.department,
                icon: Icons.work_outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppThemeProfile.primaryColor),
        const SizedBox(width: 10),
        Text(title, style: ProfileStyles.titleStyle),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppThemeProfile.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppThemeProfile.primaryColor),
          ),
          const SizedBox(width: AppTheme.defaultSpacing),
          Expanded(child: Text(label, style: ProfileStyles.labelStyle)),
          Flexible(
            child: Text(
              value,
              style: ProfileStyles.valueStyle,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppThemeProfile.horizontalPadding,
      ),
      child: Column(
        children: [
          ActionButton(
            onTap: () => _showLogoutDialog(context),
            icon: Icons.logout,
            label: 'Logout',
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const LogoutDialog());
  }
}

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppThemeProfile.horizontalPadding,
      ),
      child: CardContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              Text(
                'Dijalankan oleh',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: AppTheme.defaultSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const LogoWithText(
                    assetPath: 'assets/smkn.png',
                    text: 'SMKN 11 Bandung',
                  ),
                  Container(height: 40, width: 1, color: Colors.grey[300]),
                  const LogoWithText(
                    assetPath: 'assets/logo.png',
                    text: 'EduInform',
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.defaultSpacing),
              Text(
                '© 2025 SMKN 11 Bandung',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoWithText extends StatelessWidget {
  const LogoWithText({super.key, required this.assetPath, required this.text});
  final String assetPath;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: ProfileStyles.logoSize,
          width: ProfileStyles.logoSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(assetPath, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class CardContainer extends StatelessWidget {
  const CardContainer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeProfile.borderRadius),
        boxShadow: [ProfileStyles.cardShadow],
      ),
      child: child,
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
    required this.color,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppThemeProfile.borderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.defaultSpacing,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFFF8FAFC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(ProfileStyles.dialogPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.defaultSpacing),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout, color: Colors.red, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.defaultSpacing),
            Text(
              'Apakah Anda yakin ingin logout?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(child: DialogCancelButton()),
                SizedBox(width: AppTheme.defaultSpacing),
                Expanded(child: DialogLogoutButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DialogCancelButton extends StatelessWidget {
  const DialogCancelButton({super.key});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Text(
        'Cancel',
        style: GoogleFonts.poppins(
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class DialogLogoutButton extends StatelessWidget {
  const DialogLogoutButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.pop(context);
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
          (route) => false,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        'Logout',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
