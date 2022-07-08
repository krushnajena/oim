class ChatModel {
  String? sellerid;
  String? sellername;
  String? sellerlogo;
  String? userid;
  String? username;
  String? productid;
  String? productname;
  String? productlogo;
  String? productprice;
  String? lastMessage;
  String? isDeletdBySeller;
  String? isDeletdByByer;

  String? isBlockedByByer;
  String? isBlockedBySeller;

  String? isByerUnred;
  String? isSellerUnred;
  ChatModel(
      {this.sellerid,
      this.sellername,
      this.sellerlogo,
      this.userid,
      this.username,
      this.productid,
      this.productname,
      this.productlogo,
      this.productprice,
      this.lastMessage,
      this.isDeletdBySeller,
      this.isDeletdByByer,
      this.isBlockedByByer,
      this.isBlockedBySeller,
      this.isByerUnred,
      this.isSellerUnred});

  Map<String, String> toMap() {
    var map = Map<String, String>();

    map['sellerid'] = this.sellerid!;
    map['sellername'] = this.sellername!;
    map['sellerlogo'] = this.sellerlogo!;

    map['userid'] = this.userid!;
    map['username'] = this.username!;

    map['productid'] = this.productid!;
    map['productname'] = this.productname!;

    map['productlogo'] = this.productlogo!;
    map['productprice'] = this.productprice!;
    map['lastMessage'] = this.lastMessage!;

    map['isDeletdBySeller'] = this.isDeletdBySeller!;
    map['isDeletdByByer'] = this.isDeletdByByer!;

    map['isBlockedByByer'] = this.isBlockedByByer!;
    map['isBlockedBySeller'] = this.isBlockedBySeller!;

    map['isByerUnred'] = this.isByerUnred!;
    map['isSellerUnred'] = this.isSellerUnred!;
    return map;
  }

  // named constructor
  ChatModel.fromMap(Map<String, dynamic> map) {
    this.sellerid = sellerid;
    this.sellername = map['sellername'];
    this.sellerlogo = map['sellerlogo'];

    this.userid = map['userid'];
    this.username = map['username'];

    this.productid = map['productid'];
    this.productname = map['productname'];

    this.productlogo = map['productlogo'];
    this.productprice = map['productprice'];
    this.lastMessage = map['lastMessage'];

    this.isDeletdBySeller = map['isDeletdBySeller'];
    this.isDeletdByByer = map['isDeletdByByer'];

    this.isBlockedByByer = map['isBlockedByByer'];
    this.isBlockedBySeller = map['isBlockedBySeller'];

    this.isByerUnred = map['isByerUnred'];
    this.isSellerUnred = map['isSellerUnred'];
  }
}
