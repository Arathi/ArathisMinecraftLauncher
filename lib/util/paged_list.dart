class PagedList<T> {
  int index = 0;
  int size = 0;
  int get count => datas.length;
  int total = 0;
  late List<T> datas;

  PagedList(this.index, this.size, this.total, this.datas);

  PagedList.none() : datas = <T>[];
}
