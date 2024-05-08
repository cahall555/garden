class WaterSchedule {
	final String id;
  	final bool monday;
  	final bool tuesday;
  	final bool wednesday;
  	final bool thursday;
  	final bool friday;
  	final bool saturday;
  	final bool sunday;
	final String method;
	final String notes;
	final String plant_id;
	final DateTime createdAt;
	final DateTime updatedAt;

  	WaterSchedule({required this.id, required this.monday, required this.tuesday, required this.wednesday, required this.thursday, required this.friday, required this.saturday, required this.sunday, required this.method, required this.notes, required this.plant_id, required this.createdAt, required this.updatedAt});

  	factory WaterSchedule.fromJson(Map<String, dynamic> json) {
    		return WaterSchedule(
      			id: json['id'],
      			monday: json['monday'],
      			tuesday: json['tuesday'],
			wednesday: json['wednesday'],
			thursday: json['thursday'],
			friday: json['friday'],
			saturday: json['saturday'],
			sunday: json['sunday'],
			method: json['method'],
			notes: json['notes'],
			plant_id: json['plant_id'],
			createdAt: DateTime.parse(json['created_at']),
			updatedAt: DateTime.parse(json['updated_at']),
    		);
  	}

  	Map<String, dynamic> toJson() {
    		return {
      			'id': id,
      			'monday': monday,
      			'tuesday': tuesday,
			'wednesday': wednesday,
			'thursday': thursday,
			'friday': friday,
			'saturday': saturday,
			'sunday': sunday,
			'method': method,
			'notes': notes,
			'plant_id': plant_id,
			'created_at': createdAt.toIso8601String(),
			'updated_at': updatedAt.toIso8601String(),
    		};
  	}
}
