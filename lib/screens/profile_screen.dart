import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ─── Header ─────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            33,
                            9,
                            217,
                          ).withOpacity(0.3),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 44),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'SAKHER MOHAMMED',
                    style: TextStyle(
                      color: AppTheme.textLightPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'sakhermohammed@email.com',
                    style: TextStyle(
                      color: AppTheme.textLightMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ─── Menu Items ─────────────────────────────────────
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildMenuItem(Icons.shopping_bag_outlined, 'My Orders'),
                  _buildMenuItem(Icons.location_on_outlined, 'Shipping Address'),
                  _buildMenuItem(Icons.payment_outlined, 'Payment Methods'),
                  _buildMenuItem(Icons.notifications_outlined, 'Notifications'),
                  _buildMenuItem(Icons.lock_outline_rounded, 'Privacy & Security'),
                  _buildMenuItem(Icons.help_outline_rounded, 'Help & Support'),
                  _buildMenuItem(Icons.logout_rounded, 'Log Out', isLogout: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {bool isLogout = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isLogout
                ? AppTheme.neonRed.withOpacity(0.1)
                : AppTheme.blueAccent.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isLogout ? AppTheme.neonRed : AppTheme.blueAccent,
            size: 20,
          ),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isLogout ? AppTheme.neonRed : AppTheme.textLightPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isLogout
            ? null
            : Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppTheme.textLightMuted),
        onTap: () {},
      ),
    );
  }
}
