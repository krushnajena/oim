class NewProductSearch {
  final String? productname;

  NewProductSearch({this.productname});

  factory NewProductSearch.fromJson(Map<String, dynamic> json) {
    return NewProductSearch(productname: json['productname']);
  }
}
