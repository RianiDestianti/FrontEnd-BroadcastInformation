import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'changepassword.dart';
import '../layouts/layout.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const Color themeColor = Color(0xFF57B4BA);
  static const double horizontalPadding = 24.0;
  static const double borderRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 3,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              ProfileHeader(),
              SizedBox(height: 24),
              PersonalInformation(),
              SizedBox(height: 24),
              ChangePasswordButton(),
              SizedBox(height: 16),
              LogoutButton(),
              SizedBox(height: 40),
              AppFooter(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFBFE8EB), Colors.white],
        ),
      ),
      child: Column(
        children: const [
          HeaderNavigation(),
          SizedBox(height: 20),
          ProfileAvatar(),
          SizedBox(height: 16),
          ProfileName(),
          DepartmentBadge(),
        ],
      ),
    );
  }
}

class HeaderNavigation extends StatelessWidget {
  const HeaderNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: const CircleAvatar(
        radius: 55,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Color(0x33_57B4BA),
          child: Icon(Icons.person, size: 50, color: ProfilePage.themeColor),
        ),
      ),
    );
  }
}

class ProfileName extends StatelessWidget {
  const ProfileName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Elara Zafira',
      style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}

class DepartmentBadge extends StatelessWidget {
  const DepartmentBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ProfilePage.themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school, size: 16, color: ProfilePage.themeColor),
          const SizedBox(width: 6),
          Text(
            'Rekayasa Perangkat Lunak',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: ProfilePage.themeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class PersonalInformation extends StatelessWidget {
  const PersonalInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ProfilePage.horizontalPadding,
      ),
      child: CardContainer(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SectionTitle(
                title: 'Personal Information',
                icon: Icons.person_outline,
              ),
              SizedBox(height: 8),
              Divider(thickness: 1),
              SizedBox(height: 8),
              InfoRow(
                label: 'Full Name',
                value: 'Elara Zafira',
                icon: Icons.badge_outlined,
              ),
              InfoRow(
                label: 'Student ID',
                value: '093264',
                icon: Icons.credit_card,
              ),
              InfoRow(
                label: 'Role',
                value: 'Siswa',
                icon: Icons.school_outlined,
              ),
              InfoRow(
                label: 'Email',
                value: 'laraza@gmail.com',
                icon: Icons.email_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const SectionTitle({Key? key, required this.title, required this.icon})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: ProfilePage.themeColor),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ProfilePage.themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: ProfilePage.themeColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ChangePasswordButton extends StatelessWidget {
  const ChangePasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ProfilePage.horizontalPadding,
      ),
      child: ActionButton(
        onTap: () => _navigateToChangePassword(context),
        icon: Icons.lock_outline,
        label: 'Change Password',
        color: ProfilePage.themeColor,
      ),
    );
  }

  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ProfilePage.horizontalPadding,
      ),
      child: ActionButton(
        onTap: () => _showLogoutDialog(context),
        icon: Icons.logout,
        label: 'Logout',
        color: ProfilePage.themeColor,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const LogoutDialog(),
    );
  }
}

class AppFooter extends StatelessWidget {
  const AppFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ProfilePage.horizontalPadding,
      ),
      child: CardContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              Text(
                'Powered by',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  LogoWithText(
                    assetPath: 'assets/smkn.png',
                    text: 'SMKN 11 Bandung',
                  ),
                  VerticalDivider(),
                  LogoWithText(assetPath: 'assets/logo.png', text: 'EduInform'),
                ],
              ),
              const SizedBox(height: 16),
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

class VerticalDivider extends StatelessWidget {
  const VerticalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(height: 40, width: 1, color: Colors.grey[300]);
  }
}

class LogoWithText extends StatelessWidget {
  final String assetPath;
  final String text;
  const LogoWithText({Key? key, required this.assetPath, required this.text})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipOval(child: Image.asset(assetPath, fit: BoxFit.contain)),
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
  final Widget child;
  const CardContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ProfilePage.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color color;

  const ActionButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ProfilePage.borderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ProfilePage.themeColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout,
                color: ProfilePage.themeColor,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Are you sure you want to logout?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(child: CancelButton()),
                SizedBox(width: 16),
                Expanded(child: ConfirmLogoutButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({Key? key}) : super(key: key);

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

class ConfirmLogoutButton extends StatelessWidget {
  const ConfirmLogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ProfilePage.themeColor,
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
