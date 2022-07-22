const baseUrl = "https://oimnewapp.herokuapp.com/";
const get_UserDetailsByMobileNoAndUserType = baseUrl + "user/getuserdetails/";
const post_register = baseUrl + "reg";
const post_login = baseUrl + "user/login";
const get_categoris = baseUrl + "categoryview";
const post_seller_register = baseUrl + "createseller";
const get_catelogues = baseUrl + "catalogue/getcatalogue/";
const get_sellerdetalsbyuserid = baseUrl + "getseller/";
const get_products_byuserid = baseUrl + "getproductbysellerid/";
const post_stock_update = baseUrl + "updateproductinstock";
const get_ad_packages = baseUrl + "getaddpackage";
const get_no_of_ad_credits = baseUrl + "getnoofaddscredit/";
const get_no_of_ad_used = baseUrl + "getnoofusedad/";
const post_ad = baseUrl + "postad";
const get_adds_by_sellerid = baseUrl + "getaddetails/";
const post_add_product = baseUrl + "createproduct";
const get_featured_ad_package = baseUrl + "getadfeatures";
const get_story_by_userid = baseUrl + "getstorybyuserid/";
const post_story_create = baseUrl + "poststory";
const get_image_banner = baseUrl + "getbanner";
const get_popular_stores = baseUrl + "getpopularstore";
const get_follwers_by_sellerid = baseUrl + "getfollowersbysellerid/";
const get_follwed_or_not = baseUrl + "getfollowers/";
const follow = baseUrl + "followers/";
const un_follow = baseUrl + "unfollow/";
const get_Product_Details = baseUrl + "productfetchbyproductid/";
const get_seller_and_products = baseUrl + "productfetchbyuserid";
const get_stories_seller = baseUrl + "storiesBySeller";
const post_chat = baseUrl + "creatchat";
const get_userchat = baseUrl + "getUserChats/";
const get_sellerchat = baseUrl + "getSellerChats/";

const get_ads = baseUrl + "get_ads";
const get_item_added_or_not = baseUrl + "getItemsAddedOrNot/";
const postAddToCart = baseUrl + "postAddToCart";
const get_cart_or_wishlist_items = baseUrl + "getItems/";
const get_removeItem = baseUrl + "getRemoveItem/";
const get_movetocart = baseUrl + "getMoveTocART/";
const get_deleteproduct = baseUrl + "deleteproduct/";
const post_updateseller = baseUrl + "updateseller";
const new_login = baseUrl + "newuserlogin";
const get_notifications = baseUrl + "getnotifications";
const post_updatespesifications = baseUrl + "productSpecificationUpdate";
const updatepassword = baseUrl + "updatepassword";
const mystores = baseUrl + "myseller/";
const apply_ratting = baseUrl + "poststoreratting";
const get_rattings = baseUrl + "getstoreratting/";
const get_appliedrattings = baseUrl + "getstorerattingappliedorno/";
const get_states = baseUrl + "getstate";
const get_city = baseUrl + "getcitybystateid/";
const getareabycityid = baseUrl + "getareabycityid/";
const getareasearch = baseUrl + "getareasearch/";

const updateproduct = baseUrl + "productUpdate";
const postrestaurantimage = baseUrl + "postrestaurantimage";

const getRestaurentImageBySellerId = baseUrl + "getRestaurentImageBySellerId/";
const getSubcategoriesByCatelogid = baseUrl + "getSubcategoriesByCatelogid/";

const getDeleteStory = baseUrl + "getDeleteStory/";
const getproductsearch = baseUrl + "getproductsearch/";

const postcus = baseUrl + "postcus";
const getcusinesbyuserid = baseUrl + "getcusinesbyuserid/";
const getproductsearchseller = baseUrl + "getproductsearchseller/";

const postview = baseUrl + "postview";
const getlifetimeviews = baseUrl + "getlifetimeviews/";
