import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:cinema/theme.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    Key? key,
    this.description = '',
    required this.onTap,
  }) : super(key: key);

  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CinemaTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('errorOccured'.i18n(), style: CinemaTheme.detailsTextStyle),
            Text(
              description,
              style: CinemaTheme.detailsTextStyle.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 32),
            InkWell(
              onTap: onTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 48),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'tryAgain'.i18n(),
                  style: CinemaTheme.detailsTextStyle.copyWith(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
