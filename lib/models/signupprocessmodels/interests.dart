// class Interests {
//   bool? success;
//   String? message;
//   List<Data>? data;

//   Interests({this.success, this.message, this.data});

//   Interests.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(Data.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['success'] = success;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }

//   /// Initial factory
//   factory Interests.initial() {
//     return Interests(
//       success: false,
//       message: "",
//       data: [],
//     );
//   }

//   /// CopyWith
//   Interests copyWith({
//     bool? success,
//     String? message,
//     List<Data>? data,
//   }) {
//     return Interests(
//       success: success ?? this.success,
//       message: message ?? this.message,
//       data: data ?? this.data,
//     );
//   }
// }

// class Data {
//   int? id;
//   String? interests;

//   Data({this.id, this.interests});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     interests = json['interests'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['id'] = id;
//     data['interests'] = interests;
//     return data;
//   }

//   /// Initial factory
//   factory Data.initial() {
//     return Data(
//       id: 0,
//       interests: "",
//     );
//   }

//   /// CopyWith
//   Data copyWith({
//     int? id,
//     String? interests,
//   }) {
//     return Data(
//       id: id ?? this.id,
//       interests: interests ?? this.interests,
//     );
//   }
// }
