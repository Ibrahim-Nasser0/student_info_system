class SearchingMethodsModel {
  final String text;
  final int index;
  bool isSelected;
  SearchingMethodsModel({
    required this.text,
    required this.index,
    this.isSelected = false,
  });
}
