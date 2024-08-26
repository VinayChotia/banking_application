
// import 'dart:math';

// enum Priority { high, medium, low }

// enum Status { open, inProgress, closed }

// enum Field { enterprise, government, private }

// class Incident extends Equatable {
//   final String id;
//   final String title;
//   final String description;
//   final Priority priority;
//   final Status status;
//   final Field field;
//   final String reporterName;

//   final DateTime createdAt;

//   const Incident({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.priority,
//     required this.status,
//     required this.field,
//     required this.reporterName,
//     required this.createdAt,
//   });

//   static List<Incident> incidents = [
//     Incident(
//       id: _generateId(),
//       title: 'Cybersecurity Breach',
//       description:
//           'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eget mauris a tellus tempor hendrerit.',
//       priority: Priority.high,
//       status: Status.open,
//       field: Field.enterprise,
//       reporterName: 'Vinay',
//       createdAt: DateTime.now().subtract(Duration(days: 1)),
//     ),
//     Incident(
//       id: _generateId(),
//       title: 'Data Loss Incident',
//       description:
//           'Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.',
//       priority: Priority.medium,
//       status: Status.inProgress,
//       field: Field.government,
//       reporterName: 'Ravi',
//       createdAt: DateTime.now().subtract(Duration(days: 2)),
//     ),
//     Incident(
//       id: _generateId(),
//       title: 'Security Breach',
//       description:
//           'Donec ullamcorper nulla non metus auctor fringilla. Cras justo odio, dapibus ac facilisis in, egestas eget quam.',
//       priority: Priority.low,
//       status: Status.closed,
//       field: Field.private,
//       reporterName: 'Om Rai',
//       createdAt: DateTime.now().subtract(Duration(days: 3)),
//     ),
//   ];

//   static String _generateId() {
//     String year = DateTime.now().year.toString();
//     String randomDigits = (Random().nextInt(90000) + 10000).toString();
//     return 'RMG$randomDigits$year';
//   }

//   @override
//   List<Object?> get props => [
//         id,
//         title,
//         description,
//         priority,
//         status,
//         field,
//         reporterName,
//         createdAt,
//       ];
// }
