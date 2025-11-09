import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../widgets/primary_button.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  static const String routeName = '/auth';

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AppState>().signIn(_nameController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Assalamu’alaikum', style: theme.textTheme.headlineLarge),
              const SizedBox(height: 12),
              Text(
                _isLogin
                    ? 'Welcome back! Continue your personalised Quran journey.'
                    : 'Create your account to unlock AI recitation feedback and live halaqah circles.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    if (!_isLogin)
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (String? value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      )
                    else
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Display name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email address',
                        prefixIcon: Icon(Icons.alternate_email_outlined),
                      ),
                      validator: (String? value) {
                        if ((value ?? '').isEmpty || !(value?.contains('@') ?? false)) {
                          return 'Provide a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (String? value) {
                        if ((value ?? '').length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: _isLogin ? 'Sign in' : 'Create account',
                      icon: Icons.login,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(_isLogin
                          ? 'New to JomNgaji? Create account'
                          : 'Already have an account? Sign in'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              _FeatureCallouts(theme: theme),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCallouts extends StatelessWidget {
  const _FeatureCallouts({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('What you get', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        _CalloutTile(
          icon: Icons.assessment_rounded,
          title: 'AI scoring & tajweed heatmaps',
          description:
              'Automated alignment compares your audio against expert recitations to highlight strengths and improvement areas.',
        ),
        const SizedBox(height: 12),
        _CalloutTile(
          icon: Icons.play_lesson,
          title: 'Interactive practice studio',
          description:
              'Loop tricky ayat, slow playback, and receive instant articulation tips guided by our virtual ustaz.',
        ),
        const SizedBox(height: 12),
        _CalloutTile(
          icon: Icons.spa_rounded,
          title: 'Daily mindfulness reminders',
          description:
              'Stay consistent with reflections, dhikr prompts, and scheduled recitation sprints.',
        ),
      ],
    );
  }
}

class _CalloutTile extends StatelessWidget {
  const _CalloutTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(description, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
