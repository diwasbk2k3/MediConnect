import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/hospital/presentation/state/rating_form_state.dart';
import 'package:mediconnect/features/hospital/presentation/view_model/rating_form_view_model.dart';
import 'package:mediconnect/core/utils/snackbar_utils.dart';

class GiveRatingForm extends ConsumerWidget {
  final String hospitalId;

  const GiveRatingForm({
    super.key,
    required this.hospitalId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingState = ref.watch(ratingFormNotifierProvider);
    final ratingNotifier = ref.read(ratingFormNotifierProvider.notifier);

    // Listen to status changes
    ref.listen(ratingFormNotifierProvider, (previous, next) {
      if (next.status == RatingFormStatus.success) {
        SnackbarUtils.showSuccess(context, 'Rating submitted successfully!');
      } else if (next.status == RatingFormStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Give Rating',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Subtitle
          const Text(
            'Share your experience with this hospital',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),

          // Star Rating
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...[1, 2, 3, 4, 5].map(
                  (star) => GestureDetector(
                    onTap: () {
                      ratingNotifier.setRating(star);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.star,
                        size: 36,
                        color: star <= ratingState.selectedRating
                            ? Colors.amber
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Rating display text
          if (ratingState.selectedRating > 0)
            Center(
              child: Text(
                '${ratingState.selectedRating} out of 5 stars',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 12),

          // Error message
          if (ratingState.status == RatingFormStatus.error && ratingState.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ratingState.errorMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (ratingState.status == RatingFormStatus.error) const SizedBox(height: 12),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade500,
                disabledBackgroundColor: Colors.amber.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: ratingState.status == RatingFormStatus.loading
                  ? null
                  : () {
                      ratingNotifier.submitRating(hospitalId);
                    },
              child: ratingState.status == RatingFormStatus.loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : const Text(
                      'Submit Feedback',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
