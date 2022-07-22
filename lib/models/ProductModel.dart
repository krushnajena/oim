class NewProductSearch {
  final String? productname;
  final String? id;

  NewProductSearch({this.productname, this.id});

  factory NewProductSearch.fromJson(Map<String, dynamic> json) {
    return NewProductSearch(productname: json['productname'], id: json['_id']);
  }
}
