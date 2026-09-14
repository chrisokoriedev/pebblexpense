import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorStateCard extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorStateCard({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 32.spMin,
                color: const Color(0xFFE53935),
              ),
            ),
            12.verticalSpace,
            Text(
              'Connection Error',
              style: TextStyle(
                fontSize: 16.spMin,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            6.verticalSpace,
            Text(
              errorMessage.contains('Connection refused')
                  ? 'Could not connect to the backend server. Ensure the server is running on port 3000.'
                  : errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.spMin,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            16.verticalSpace,
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCEF175), // Matching FAB
                foregroundColor: Colors.black,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: Text(
                'Retry',
                style: TextStyle(
                  fontSize: 13.spMin,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
