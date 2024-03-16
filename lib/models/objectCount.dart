class ObjectCount {
  final String name;
  final int count;

  const ObjectCount({required this.name, required this.count});

  factory ObjectCount.fromJson({required Map<String, dynamic> json}) =>
      ObjectCount(name: json['name'], count: json['count']);

  Map<String, dynamic> toMap() => {
        'name': name,
        'count': count,
      };
}
