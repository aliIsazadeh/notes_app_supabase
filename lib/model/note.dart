class Note {
  
  final int id;
  final String title;
  final String? content;
  final DateTime createTime;
  final DateTime modifyTime;

  Note(this.id, this.title, this.content, this.createTime, this.modifyTime);
}