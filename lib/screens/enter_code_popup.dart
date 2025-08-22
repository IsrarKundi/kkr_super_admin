import 'package:flutter/material.dart';
import '../widgets/modal_popup.dart';
import '../widgets/close_button.dart';
import '../widgets/otp_input.dart';
import '../widgets/gradient_button.dart';

class EnterCodePopup extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onNext;
  final String email;
  const EnterCodePopup({Key? key, required this.onClose, required this.onNext, required this.email}) : super(key: key);

  @override
  State<EnterCodePopup> createState() => _EnterCodePopupState();
}

class _EnterCodePopupState extends State<EnterCodePopup> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (_) => TextEditingController());
  }

  String get code => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return ModalPopup(
      onClose: widget.onClose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PopupCloseButton(onPressed: widget.onClose),
          const SizedBox(height: 8),
          const Text(
            'Enter the code',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              const Text(
                'We have just sent you a 4-digit code to',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFc89849),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          OtpInput(
            controllers: _controllers,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 32),
          GradientButton(
            text: 'Next',
            onPressed: code.length == 4 ? widget.onNext : () {},
            enabled: code.length == 4,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }
} 