class ISewooDocument {
  List<int>? content;
  bool? downToUp;
}

class SewooDocument implements ISewooDocument {
  @override
  List<int>? content;

  @override
  bool? downToUp;

  SewooDocument({
    List<int>? content,
    bool? downToUp
  }){
    this.content = content;
    this.downToUp = downToUp;
  }
}