class CountModel {
  Data? data;
  String? message;
  bool? completed;

  CountModel({this.data, this.message, this.completed});

  CountModel.fromJson(Map<String, dynamic> json) {
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
    message = json['Message'];
    completed = json['Completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    data['Message'] = message;
    data['Completed'] = completed;
    return data;
  }
}

class Data {
  int? completedJobCount;
  int? todayJobCount;
  int? tomorrowJobCount;
  int? todayPendingSignJobCount;

  Data({this.completedJobCount, this.todayJobCount, this.tomorrowJobCount});

  Data.fromJson(Map<String, dynamic> json) {
    completedJobCount = json['CompletedJobCount'] ?? 0;
    todayJobCount = json['TodayJobCount'] ?? 0;
    tomorrowJobCount = json['TomorrowJobCount'] ?? 0;
    todayPendingSignJobCount = json['todayPendingSignJobCount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CompletedJobCount'] = completedJobCount;
    data['TodayJobCount'] = todayJobCount;
    data['TomorrowJobCount'] = tomorrowJobCount;
    data['todayPendingSignJobCount'] = todayPendingSignJobCount;
    return data;
  }
}
