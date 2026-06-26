import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/drive_model.dart';
import '../models/flash_status_model.dart';
import '../models/image_model.dart';
import '../core/services/flash_service.dart';
import 'widgets/custom_button.dart';

class FlashProgressScreen extends ConsumerStatefulWidget {
  final ImageModel image;
  final DriveModel drive;

  const FlashProgressScreen({
    super.key,
    required this.image,
    required this.drive,
  });

  @override
  ConsumerState<FlashProgressScreen> createState() =>
      _FlashProgressScreenState();
}

class _FlashProgressScreenState extends ConsumerState<FlashProgressScreen> {
  final FlashService _flashService = FlashService();
  FlashStatusModel? _currentStatus;
  bool _isFlashing = false;

  @override
  void initState() {
    super.initState();
    _startFlashing();
    _subscribeToStatus();
  }

  void _startFlashing() {
    _flashService.flashImage(widget.image, widget.drive);
  }

  void _subscribeToStatus() {
    _flashService.statusStream.listen(
      (status) {
        setState(() {
          _currentStatus = status;
          _isFlashing = true;

          if (status.state == FlashState.completed ||
              status.state == FlashState.failed ||
              status.state == FlashState.cancelled) {
            _isFlashing = false;
            _showCompletionDialog();
          }
        });
      },
      onError: (error) {
        setState(() {
          _isFlashing = false;
          _currentStatus = _currentStatus?.copyWith(
            state: FlashState.failed,
            errorMessage: error.toString(),
          );
        });
        _showCompletionDialog();
      },
    );
  }

  void _showCompletionDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  _currentStatus?.state == FlashState.completed
                      ? Icons.check_circle
                      : Icons.error,
                  color: _currentStatus?.state == FlashState.completed
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  _currentStatus?.state == FlashState.completed
                      ? 'Success!'
                      : _currentStatus?.state == FlashState.cancelled
                      ? 'Cancelled'
                      : 'Failed!',
                ),
              ],
            ),
            content: Text(
              _currentStatus?.state == FlashState.completed
                  ? 'Image flashed successfully to ${widget.drive.name}!'
                  : _currentStatus?.errorMessage ??
                        'An error occurred during flashing.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  void _pauseFlash() {
    if (_currentStatus?.state == FlashState.writing) {
      _flashService.pause();
    } else if (_currentStatus?.state == FlashState.paused) {
      _flashService.resume();
    }
  }

  void _cancelFlash() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Flashing?'),
        content: const Text(
          'Are you sure you want to cancel the flashing process?\n\nThis may leave the drive in an inconsistent state.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _flashService.cancel();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _currentStatus?.state ?? FlashState.idle;
    final isComplete =
        state == FlashState.completed ||
        state == FlashState.failed ||
        state == FlashState.cancelled;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashing Progress'),
        automaticallyImplyLeading: false,
        leading: isComplete
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildInfoCard(),
              const SizedBox(height: 24),
              _buildProgressSection(),
              const SizedBox(height: 24),
              _buildStatsSection(),
              const Spacer(),
              _buildControlButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.image, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Image',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        widget.image.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Icon(Icons.usb, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Drive',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '${widget.drive.name} (${widget.drive.path})',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        _currentStatus?.currentStage ?? 'Preparing...',
                        style: TextStyle(
                          color: _getStatusColor(_currentStatus?.state),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    final progress = _currentStatus?.progress ?? 0.0;
    final state = _currentStatus?.state ?? FlashState.idle;
    final isError = state == FlashState.failed || state == FlashState.cancelled;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isError ? Colors.red.shade100 : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _currentStatus?.formattedBytesWritten ?? '0 B',
                  style: TextStyle(
                    color: isError ? Colors.red.shade700 : Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: isError ? 0 : progress,
              minHeight: 12,
              backgroundColor: Colors.grey.shade300,
              color: isError ? Colors.red : Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${_currentStatus?.formattedTotalBytes ?? '0 B'}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              Text(
                _currentStatus?.timeElapsed ?? '0s',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final status = _currentStatus;
    if (status == null) return const SizedBox.shrink();

    return Row(
      children: [
        _buildStatCard(
          icon: Icons.speed,
          label: 'Speed',
          value: status.formattedSpeed,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          icon: Icons.timer,
          label: 'Remaining',
          value: status.estimatedTimeRemaining.toString(),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          icon: Icons.data_usage,
          label: 'Written',
          value: status.formattedBytesWritten,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade600),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    final state = _currentStatus?.state ?? FlashState.idle;
    final isPaused = state == FlashState.paused;
    final isInProgress =
        state == FlashState.writing ||
        state == FlashState.preparing ||
        state == FlashState.verifying;
    final isComplete =
        state == FlashState.completed ||
        state == FlashState.failed ||
        state == FlashState.cancelled;

    if (isComplete) {
      return CustomButton(
        onPressed: () => Navigator.pop(context),
        text: 'Close',
        icon: const Icon(Icons.close),
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
    }

    if (!isInProgress && !isPaused) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Expanded(
          child: CustomButton(
            onPressed: _pauseFlash,
            text: isPaused ? 'Resume' : 'Pause',
            icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
            backgroundColor: isPaused ? Colors.green : Colors.orange,
            textColor: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomButton(
            onPressed: _cancelFlash,
            text: 'Cancel',
            icon: const Icon(Icons.cancel),
            backgroundColor: Colors.red,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(FlashState? state) {
    switch (state) {
      case FlashState.completed:
        return Colors.green;
      case FlashState.failed:
      case FlashState.cancelled:
        return Colors.red;
      case FlashState.paused:
        return Colors.orange;
      case FlashState.writing:
      case FlashState.preparing:
      case FlashState.verifying:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
