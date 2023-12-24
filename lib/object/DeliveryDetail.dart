class DeliveryDetail {
  final String name;
  final String description;
  final List<String> renders;
  final List<String> parses;
  final DeliveryActions actions;

  DeliveryDetail({
    required this.name,
    required this.description,
    required this.renders,
    required this.parses,
    required this.actions,
  });

  factory DeliveryDetail.fromJson(Map<String, dynamic> json) {
    return DeliveryDetail(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      renders: List<String>.from(json['renders'] ?? []),
      parses: List<String>.from(json['parses'] ?? []),
      actions: DeliveryActions.fromJson(json['actions'] ?? {}),
    );
  }
}

class DeliveryActions {
  final DeliveryActionPut put;

  DeliveryActions({
    required this.put,
  });

  factory DeliveryActions.fromJson(Map<String, dynamic> json) {
    return DeliveryActions(
      put: DeliveryActionPut.fromJson(json['PUT'] ?? {}),
    );
  }
}

class DeliveryActionPut {
  final DeliveryField noDelivery;
  final DeliveryField date;
  final DeliveryField customerName;
  final DeliveryField address;
  final DeliveryField custLat;
  final DeliveryField custLon;
  final DeliveryField cp;
  final DeliveryField hp;
  final DeliveryField driverName;
  final DeliveryField driverLat;
  final DeliveryField driverLon;
  final DeliveryField photo;
  final DeliveryField status;

  DeliveryActionPut({
    required this.noDelivery,
    required this.date,
    required this.customerName,
    required this.address,
    required this.custLat,
    required this.custLon,
    required this.cp,
    required this.hp,
    required this.driverName,
    required this.driverLat,
    required this.driverLon,
    required this.photo,
    required this.status,
  });

  factory DeliveryActionPut.fromJson(Map<String, dynamic> json) {
    return DeliveryActionPut(
      noDelivery: DeliveryField.fromJson(json['no_delivery'] ?? {}),
      date: DeliveryField.fromJson(json['date'] ?? {}),
      customerName: DeliveryField.fromJson(json['customer_name'] ?? {}),
      address: DeliveryField.fromJson(json['address'] ?? {}),
      custLat: DeliveryField.fromJson(json['cust_lat'] ?? {}),
      custLon: DeliveryField.fromJson(json['cust_lon'] ?? {}),
      cp: DeliveryField.fromJson(json['cp'] ?? {}),
      hp: DeliveryField.fromJson(json['hp'] ?? {}),
      driverName: DeliveryField.fromJson(json['driver_name'] ?? {}),
      driverLat: DeliveryField.fromJson(json['driver_lat'] ?? {}),
      driverLon: DeliveryField.fromJson(json['driver_lon'] ?? {}),
      photo: DeliveryField.fromJson(json['photo'] ?? {}),
      status: DeliveryField.fromJson(json['status'] ?? {}),
    );
  }
}

class DeliveryField {
  final String type;
  final bool required;
  final bool readOnly;
  final String label;
  final double? maxLength; // Note: Max length is a double in the response

  DeliveryField({
    required this.type,
    required this.required,
    required this.readOnly,
    required this.label,
    this.maxLength,
  });

  factory DeliveryField.fromJson(Map<String, dynamic> json) {
    return DeliveryField(
      type: json['type'] ?? '',
      required: json['required'] ?? false,
      readOnly: json['read_only'] ?? false,
      label: json['label'] ?? '',
      maxLength: json['max_length']?.toDouble(),
    );
  }
}
