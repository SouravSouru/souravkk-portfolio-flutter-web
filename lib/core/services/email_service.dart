import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

/// Result of an email send attempt
class EmailResult {
  final bool success;
  final String message;
  final bool usedFallback;

  const EmailResult({
    required this.success,
    required this.message,
    this.usedFallback = false,
  });
}

/// Service for sending contact form emails.
///
/// Uses EmailJS (https://www.emailjs.com) as the primary method.
/// Falls back to a mailto: link if EmailJS fails or is not configured.
///
/// ## Setup Instructions (EmailJS - Free Tier: 200 emails/month):
/// 1. Go to https://www.emailjs.com and create a free account
/// 2. Add an Email Service (e.g., Gmail) under "Email Services"
/// 3. Create an Email Template under "Email Templates" with these variables:
///    - {{from_name}} — sender's name
///    - {{from_email}} — sender's email
///    - {{message}} — the message body
///    - {{to_name}} — your name (auto-filled)
/// 4. Copy your Service ID, Template ID, and Public Key
/// 5. Replace the placeholder values below with your actual IDs
class EmailService {
  // ══════════════════════════════════════════════════════════════════════════
  // ⚙️  CONFIGURATION — Replace these with your EmailJS credentials
  // ══════════════════════════════════════════════════════════════════════════
  static const String _serviceId = 'YOUR_SERVICE_ID'; // e.g., 'service_abc123'
  static const String _templateId =
      'YOUR_TEMPLATE_ID'; // e.g., 'template_xyz789'
  static const String _publicKey =
      'YOUR_PUBLIC_KEY'; // e.g., 'aBcDeFgHiJkLmNoPq'
  // ══════════════════════════════════════════════════════════════════════════

  static const String _emailJsUrl =
      'https://api.emailjs.com/api/v1.0/email/send';

  /// The recipient email for fallback mailto links
  static const String _recipientEmail = 'souravkk2021@gmail.com';
  static const String _recipientName = 'Sourav K K';

  /// Check if EmailJS is properly configured (not using placeholder values)
  static bool get isConfigured =>
      _serviceId != 'YOUR_SERVICE_ID' &&
      _templateId != 'YOUR_TEMPLATE_ID' &&
      _publicKey != 'YOUR_PUBLIC_KEY';

  /// Send an email using EmailJS API with a mailto: fallback.
  ///
  /// Returns an [EmailResult] indicating success/failure and whether
  /// the fallback was used.
  static Future<EmailResult> sendEmail({
    required String name,
    required String email,
    required String message,
  }) async {
    // If EmailJS is configured, try sending via API first
    if (isConfigured) {
      try {
        final response = await http
            .post(
              Uri.parse(_emailJsUrl),
              headers: {
                'Content-Type': 'application/json',
                'origin': 'http://localhost',
              },
              body: jsonEncode({
                'service_id': _serviceId,
                'template_id': _templateId,
                'user_id': _publicKey,
                'template_params': {
                  'from_name': name,
                  'from_email': email,
                  'message': message,
                  'to_name': _recipientName,
                },
              }),
            )
            .timeout(const Duration(seconds: 15));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return const EmailResult(
            success: true,
            message: 'Message sent successfully!',
          );
        } else {
          // API returned an error – try fallback
          return await _sendViaMailto(name: name, email: email, message: message);
        }
      } catch (e) {
        // Network error or timeout – try fallback
        return await _sendViaMailto(name: name, email: email, message: message);
      }
    }

    // EmailJS not configured – use mailto directly
    return await _sendViaMailto(name: name, email: email, message: message);
  }

  /// Fallback: open the user's default email client via mailto: link
  static Future<EmailResult> _sendViaMailto({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      final subject = Uri.encodeComponent(
        'Portfolio Contact from $name',
      );
      final body = Uri.encodeComponent(
        'Name: $name\n'
        'Email: $email\n\n'
        'Message:\n$message',
      );

      final uri = Uri.parse(
        'mailto:$_recipientEmail?subject=$subject&body=$body',
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return const EmailResult(
          success: true,
          message:
              'Your email client has been opened with the message pre-filled. '
              'Please hit send in your email app.',
          usedFallback: true,
        );
      } else {
        return const EmailResult(
          success: false,
          message:
              'Could not open email client. Please email me directly at $_recipientEmail',
        );
      }
    } catch (e) {
      return EmailResult(
        success: false,
        message:
            'Something went wrong. Please email me directly at $_recipientEmail',
      );
    }
  }
}
