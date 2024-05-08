import 'journal.dart';
import 'apis/journal_api.dart';
import 'ws.dart';
import 'apis/ws_api.dart';
import 'tag.dart';
import 'apis/tag_api.dart';

class Plant {
	final String id;
	final String name;
  	final bool germinated;
	final int days_to_harvest;
	final String garden_id;
	final List<Tag>? plantTags;
  	final List<Journal>? journals;
  	final WaterSchedule? waterSchedules;
	final DateTime createdAt;
	final DateTime updatedAt;

  	Plant({required this.id, required this.name, required this.germinated, required this.days_to_harvest, required this.garden_id, this.plantTags, this.journals, this.waterSchedules, required this.createdAt, required this.updatedAt});

  	factory Plant.fromJson(Map<String, dynamic> json) {
    		return Plant(
      			id: json['id'],
      			name: json['name'],
      			germinated: json['germinated'],
			days_to_harvest: json['days_to_harvest'],
			garden_id: json['garden_id'],
			plantTags: json['plantTags'] != null ? List<Tag>.from(json['plantTags'].map((x) => Tag.fromJson(x))) : null,
     			journals: json['journals'] != null ? List<Journal>.from(json['journals'].map((x) => Journal.fromJson(x))) : null,
     			waterSchedules: json['waterSchedules'] != null ? WaterSchedule.fromJson(json['waterSchedules']) : null,
			createdAt: DateTime.parse(json['created_at']),
			updatedAt: DateTime.parse(json['updated_at']),
    		);
  	}

  	Map<String, dynamic> toJson() {
    		return {
      			'id': id,
      			'name': name,
      			'germinated': germinated,
			'days_to_harvest': days_to_harvest,
			'garden_id': garden_id,
			'PlantTags': plantTags?.map((x) => x.toJson()).toList(),
	      		'journals': journals?.map((x) => x.toJson()).toList(),
			'waterSchedules': waterSchedules?.toJson(),
			'created_at': createdAt.toIso8601String(),
			'updated_at': updatedAt.toIso8601String(),
    		};
  	}
}
