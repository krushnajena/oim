class NewProductSearch {
  final String? productname;
  final String? id;

  NewProductSearch({this.productname, this.id});

  factory NewProductSearch.fromJson(Map<String, dynamic> json) {
    return NewProductSearch(productname: json['productname'], id: json['_id']);
  }
}

class NewSellerSearch {
  final String? businessname;
  final String? id;

  NewSellerSearch({this.businessname, this.id});

  factory NewSellerSearch.fromJson(Map<String, dynamic> json) {
    return NewSellerSearch(businessname: json['businessname'], id: json['_id']);
  }
}
