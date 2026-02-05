import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stocktake/presentation/theme/app_text_styles.dart';

import '../../router/app_router.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/loading_button.dart';
import '../../../core/utils/validators.dart';
import 'package:cloud_functions/cloud_functions.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _organizationController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _hasInviteCode = false;
  bool _isRedeemingInvite = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _organizationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_hasInviteCode && _inviteCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your invite code'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    // Capture values BEFORE async operations (in case widget gets disposed)
    final inviteCode =
        _hasInviteCode ? _inviteCodeController.text.toUpperCase().trim() : null;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // First, create the account
    await ref.read(authControllerProvider.notifier).signUp(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          organizationName: _hasInviteCode ? '' : _organizationController.text,
          phone:
              _phoneController.text.isNotEmpty ? _phoneController.text : null,
          isInviteSignup: _hasInviteCode,
        );

    // Check if signup succeeded (use mounted check)
    if (!mounted) return;
    final authState = ref.read(authControllerProvider);
    if (authState.hasError) {
      // Signup failed, don't proceed with invite redemption
      return;
    }

    // If using invite code, redeem it after signup
    // Note: Widget may be disposed by now due to navigation, so we call directly
    if (inviteCode != null) {
      await _redeemInviteDirectly(inviteCode, scaffoldMessenger);
    }
  }

  /// Redeem invite code directly without relying on widget state
  Future<void> _redeemInviteDirectly(
      String code, ScaffoldMessengerState messenger) async {
    try {
      debugPrint('Redeeming invite code: $code');
      final callable = FirebaseFunctions.instance.httpsCallable('redeemInvite');
      final result = await callable.call({'code': code});

      debugPrint('Redeem invite result: ${result.data}');
      final data = result.data as Map<String, dynamic>;
      messenger.showSnackBar(
        SnackBar(
          content: Text(data['message'] ?? 'You have joined the organization!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } catch (e) {
      debugPrint('Redeem invite error: $e');
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to redeem invite: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    const Text(
                      'Create Account',
                      style: AppTextStyles.heading2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start your 90-day free trial',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Name field
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outlined),
                      ),
                      validator: (value) =>
                          Validators.required(value, fieldName: 'Name'),
                    ),
                    const SizedBox(height: 16),

                    // Have invite code toggle

                    SwitchListTile(
                      value: _hasInviteCode,
                      onChanged: (value) {
                        setState(() => _hasInviteCode = value);
                      },
                      title: const Text('I have an invite code'),
                      subtitle: const Text('Join an existing organization'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 16),

                    // Conditional: Organization OR Invite Code
                    if (_hasInviteCode) ...[
                      TextFormField(
                        controller: _inviteCodeController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          labelText: 'Invite Code',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          hintText: 'ABC123',
                        ),
                        validator: (value) => Validators.required(
                          value,
                          fieldName: 'Invite code',
                        ),
                      ),
                    ] else ...[
                      // Organization field
                      TextFormField(
                        controller: _organizationController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Business/Organization Name',
                          prefixIcon: Icon(Icons.business_outlined),
                        ),
                        validator: (value) => Validators.required(
                          value,
                          fieldName: 'Business name',
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),

                    // Phone field
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Phone (Optional)',
                        prefixIcon: Icon(Icons.phone_outlined),
                        hintText: '077XXXXXXX',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        return Validators.phone(value);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 16),

                    // Confirm password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) => Validators.passwordMatch(
                        value,
                        _passwordController.text,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Terms checkbox
                    CheckboxListTile(
                      value: _acceptedTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptedTerms = value ?? false;
                        });
                      },
                      title: const Text(
                        'I agree to the Terms of Service and Privacy Policy',
                        style: AppTextStyles.bodySmall,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 24),

                    // Sign up button
                    LoadingButton(
                      onPressed: _handleSignup,
                      isLoading: authState.isLoading,
                      child: const Text('Create Account'),
                    ),
                    const SizedBox(height: 24),

                    // Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.login),
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
