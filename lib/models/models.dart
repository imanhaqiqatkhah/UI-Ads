class DataModel {
  final String title;
  final String imageName;
  final double price;
  DataModel(
    this.title,
    this.imageName,
    this.price,
  );
}

List<DataModel> dataList = [
  DataModel("Short Dress", "assets/img/pexels1.jpg", 300.8),
  DataModel("Office Formals", "assets/img/pexels2.jpg", 245.2),
  DataModel("Casual Jeans", "assets/img/pexels3.jpg", 168.2),
  DataModel("Jeans Skirt", "assets/img/pexels4.jpg", 136.7),
];
