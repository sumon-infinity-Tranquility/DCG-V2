import 'package:flutter/material.dart';

import '../core/theme/dcg_theme.dart';

enum CaseStatus { open, triage, responding, resolved }

extension CaseStatusLabel on CaseStatus {
  String get label {
    switch (this) {
      case CaseStatus.open:
        return 'Open';
      case CaseStatus.triage:
        return 'Triage';
      case CaseStatus.responding:
        return 'Responding';
      case CaseStatus.resolved:
        return 'Resolved';
    }
  }

  Color get color {
    switch (this) {
      case CaseStatus.open:
        return DcgTheme.blue;
      case CaseStatus.triage:
        return DcgTheme.accent;
      case CaseStatus.responding:
        return DcgTheme.green;
      case CaseStatus.resolved:
        return DcgTheme.muted;
    }
  }
}
