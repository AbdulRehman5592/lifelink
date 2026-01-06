import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ButtonVariant {
  defaultButton,
  destructive,
  outline,
  secondary,
  ghost,
  link,
  blood,
  medicine,
  organ,
  success,
  accent,
  hero,
  emergency,
  bloodSoft,
  medicineSoft,
  organSoft,
  primarySoft,
}

enum ButtonSize {
  small,
  medium,
  large,
  xlarge,
  icon,
}

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isDisabled;
  final EdgeInsetsGeometry? padding;
  final bool fullWidth;
  final IconData? icon;
  final Color? customColor;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = ButtonVariant.defaultButton,
    this.size = ButtonSize.medium,
    this.isDisabled = false,
    this.padding,
    this.fullWidth = false,
    this.icon,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final sizeStyle = _getSizeStyle();
    final paddingStyle = padding ?? _getPaddingStyle();

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: 8),
        ],
        child,
      ],
    );

    final button = ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonStyle.backgroundColor,
        foregroundColor: buttonStyle.foregroundColor,
        disabledBackgroundColor: Colors.grey.shade300,
        disabledForegroundColor: Colors.grey.shade500,
        shadowColor: buttonStyle.shadowColor,
        elevation: buttonStyle.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonStyle.borderRadius),
          side: BorderSide(
            color: buttonStyle.borderColor ?? Colors.transparent,
            width: buttonStyle.borderWidth,
          ),
        ),
        padding: paddingStyle,
        minimumSize: sizeStyle,
        animationDuration: const Duration(milliseconds: 200),
      ),
      child: buttonChild,
    );

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  ButtonStyleData _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case ButtonVariant.defaultButton:
        return ButtonStyleData(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.3),
          borderRadius: 12,
        );

      case ButtonVariant.destructive:
        return ButtonStyleData(
          backgroundColor: const Color(0xFFE53935),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0xFFE53935).withOpacity(0.3),
          borderRadius: 12,
        );

      case ButtonVariant.outline:
        return ButtonStyleData(
          backgroundColor: Colors.transparent,
          foregroundColor: theme.primaryColor,
          borderColor: theme.primaryColor,
          borderWidth: 2,
          borderRadius: 12,
        );

      case ButtonVariant.blood:
        return ButtonStyleData(
          backgroundColor: const Color(0xFFE53935),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0xFFE53935).withOpacity(0.3),
          borderRadius: 12,
        );

      case ButtonVariant.medicine:
        return ButtonStyleData(
          backgroundColor: const Color(0xFF8E44AD),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0xFF8E44AD).withOpacity(0.3),
          borderRadius: 12,
        );

      case ButtonVariant.organ:
        return ButtonStyleData(
          backgroundColor: const Color(0xFF00A89D),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0xFF00A89D).withOpacity(0.3),
          borderRadius: 12,
        );

      case ButtonVariant.success:
        return ButtonStyleData(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0xFF4CAF50).withOpacity(0.3),
          borderRadius: 12,
        );

      case ButtonVariant.hero:
        return ButtonStyleData(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: theme.primaryColor.withOpacity(0.4),
          borderRadius: 16,
        );

      case ButtonVariant.emergency:
        return ButtonStyleData(
          backgroundColor: const Color(0xFFFF5722),
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: const Color(0xFFFF5722).withOpacity(0.4),
          borderRadius: 16,
        );

      case ButtonVariant.bloodSoft:
        return ButtonStyleData(
          backgroundColor: const Color(0xFFFFE5E5),
          foregroundColor: const Color(0xFFE53935),
          borderRadius: 12,
        );

      case ButtonVariant.medicineSoft:
        return ButtonStyleData(
          backgroundColor: const Color(0xFFF3E5F5),
          foregroundColor: const Color(0xFF8E44AD),
          borderRadius: 12,
        );

      case ButtonVariant.organSoft:
        return ButtonStyleData(
          backgroundColor: const Color(0xFFE0F2F1),
          foregroundColor: const Color(0xFF00A89D),
          borderRadius: 12,
        );

      case ButtonVariant.primarySoft:
        return ButtonStyleData(
          backgroundColor: const Color(0xFFE3F2FD),
          foregroundColor: theme.primaryColor,
          borderRadius: 12,
        );

      default:
        return ButtonStyleData(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          borderRadius: 12,
        );
    }
  }

  Size _getSizeStyle() {
    switch (size) {
      case ButtonSize.small:
        return const Size(double.infinity, 36);
      case ButtonSize.medium:
        return const Size(double.infinity, 44);
      case ButtonSize.large:
        return const Size(double.infinity, 48);
      case ButtonSize.xlarge:
        return const Size(double.infinity, 56);
      case ButtonSize.icon:
        return const Size(40, 40);
      default:
        return const Size(double.infinity, 44);
    }
  }

  EdgeInsets _getPaddingStyle() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 12);
      case ButtonSize.xlarge:
        return const EdgeInsets.symmetric(horizontal: 40, vertical: 14);
      case ButtonSize.icon:
        return const EdgeInsets.all(8);
      default:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
      case ButtonSize.xlarge:
        return 20;
      default:
        return 16;
    }
  }
}

class ButtonStyleData {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double elevation;
  final Color? shadowColor;
  final double borderRadius;

  ButtonStyleData({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    this.borderWidth = 0,
    this.elevation = 0,
    this.shadowColor,
    this.borderRadius = 8,
  });
}