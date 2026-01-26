import 'dart:async';

import 'package:flutter/material.dart';

class TimeAgoText extends StatefulWidget {
  final DateTime timestamp;
  final TextStyle style;

  const TimeAgoText({super.key, required this.timestamp, required this.style});

  @override
  State<TimeAgoText> createState() => _TimeAgoTextState();
}

class _TimeAgoTextState extends State<TimeAgoText> {
  late Timer _timer;
  String _timeAgo = '';

  @override
  void initState() {
    super.initState();
    _updateTimeAgo();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateTimeAgo();
    });
  }

  @override
  void didUpdateWidget(covariant TimeAgoText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.timestamp != widget.timestamp) {
      _updateTimeAgo();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(widget.timestamp);

    String newTimeAgo;
    if (difference.inMinutes < 1) {
      newTimeAgo = 'Just now';
    } else if (difference.inMinutes < 60) {
      newTimeAgo = '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      newTimeAgo =
          '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      newTimeAgo =
          '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      newTimeAgo =
          '${widget.timestamp.day}/${widget.timestamp.month}/${widget.timestamp.year}';
    }

    if (newTimeAgo != _timeAgo) {
      setState(() {
        _timeAgo = newTimeAgo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_timeAgo, style: widget.style);
  }
}
