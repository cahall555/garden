class SyncLog {
  final String entity;
  final DateTime? lastSyncTime;
  final String? lastSyncStatus;
  final String? lastSyncMessage;

  SyncLog({
    required this.entity,
    this.lastSyncTime,
    this.lastSyncStatus,
    this.lastSyncMessage,
  });

  factory SyncLog.fromJson(Map<String, dynamic> json) {
    return SyncLog(
      entity: json['entity'],
      lastSyncTime: json['lastSyncTime'] != null
          ? DateTime.parse(json['lastSyncTime'])
          : null,
      lastSyncStatus: json['lastSyncStatus'],
      lastSyncMessage: json['lastSyncMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entity': entity,
      'lastSyncTime': lastSyncTime?.toIso8601String(),
      'lastSyncStatus': lastSyncStatus,
      'lastSyncMessage': lastSyncMessage,
    };
  }
}

