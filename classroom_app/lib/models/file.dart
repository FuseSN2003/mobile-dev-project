import 'dart:convert';

Attachment attachmentFromJSON(String str) =>
    Attachment.fromJson(json.decode(str));

String attachmentToJSON(Attachment data) => json.encode(data.toJson());

class Attachment {
  final String url;
  final String fileName;
  final String fileType;

  Attachment({
    required this.url,
    required this.fileName,
    required this.fileType,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    url: json['url'],
    fileType: json['fileType'],
    fileName: json['fileName'],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "fileType": fileType,
    "fileName": fileName,
  };
}
