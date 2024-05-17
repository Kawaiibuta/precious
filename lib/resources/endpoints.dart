class EndPoint {
  static const baseUrl = "https://api-precious-com.onrender.com/";
  static const product = "${baseUrl}api/product/";
  static String productWithParam(
          {int start = 1, int quantity = -1, int type = -1}) =>
      "${baseUrl}api/product?start=$start&quantity=$quantity${type != -1 ? "&type=$type" : ""}";
  static const category = "${baseUrl}api/category/";
  static String productDetail(int id) => product + id.toString();
  static String categoryDetail(int id) => category + id.toString();
  static const type = "${baseUrl}api/type/";
  static const variant = "${baseUrl}api/variant/";
  static String productVariant(int id) => variant + id.toString();
  static const order = "${baseUrl}api/order/";
  static String orderDetail(int id) => order + id.toString();
  static const user = "${baseUrl}api/user/";
  static String userDetail(int id) => user + id.toString();
}
