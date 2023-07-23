class QuoteModel {
  String? content;
  String? author;
  String? tags;

  QuoteModel({
    this.content,
    this.author,
    this.tags,
  });

  QuoteModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    author = json['author'];
    tags = json['tags'][0];
  }
}
