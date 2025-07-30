import 'package:flutter/material.dart';
import 'package:flutter_app/core/app_colors.dart';
import 'auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();

  final AuthService _authService = AuthService();

  String? _verificationId;
  bool _codeSent = false;
  bool _loading = false;
  bool _phoneError = false;

  void _sendCode() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty || !phone.startsWith('+') || phone.length < 10) {
      setState(() => _phoneError = true);
      return;
    }

    setState(() {
      _loading = true;
      _phoneError = false;
    });

    await _authService.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        await _authService.signInWithCredential(credential);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Успешный вход (автоматически)')),
          );
        }
      },
      verificationFailed: (error) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка верификации: $error')));
      },
      codeSent: (verificationId) {
        setState(() {
          _loading = false;
          _codeSent = true;
          _verificationId = verificationId;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Код отправлен')));
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void _verifyCode() async {
    final smsCode = _smsCodeController.text.trim();

    if (smsCode.isEmpty || _verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите код подтверждения')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await _authService.signInWithSmsCode(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Успешный вход!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка входа: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _codeSent ? _buildSmsCodeInput() : _buildPhoneInput(),
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Регистрация',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        const Text(
          'Введите номер телефона \nчтобы продолжить регистрацию',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Номер телефона',
            hintText: '+996 000 000 000',
            filled: true,
            fillColor: AppColors.grayColor,
            hintStyle: TextStyle(
              color: AppColors.numberTextColor,
              fontSize: 16,
            ),
            labelStyle: TextStyle(
              color: AppColors.secondaryTextColor,
              fontSize: 16,
            ),
            errorText: _phoneError ? 'Номер введён некорректно' : null,
            errorStyle: TextStyle(color: AppColors.errorColor),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _phoneError ? AppColors.errorColor : AppColors.mainColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _loading ? null : _sendCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Далее',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
        ),
        const SizedBox(height: 40),
        const Text(
          'Нажимая на кнопку “Дальше”, вы принимаете условия политики конфиденциальности',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSmsCodeInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _smsCodeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Код из SMS',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _loading ? null : _verifyCode,
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Подтвердить код'),
        ),
      ],
    );
  }
}
