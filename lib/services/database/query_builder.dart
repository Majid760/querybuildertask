class QueryBuilder {
  // insert e.g 'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)';
  
  static String insertQueryBuilder(Map<String, dynamic> data) {
    final keys = data.keys;
    List<String> lstString = data.values.map((e) {
      String sq = e.toString();
      if (sq.contains('\'')) {
        String rep = r"''";
        sq = sq.replaceAll('\'', rep);
      }
      return (sq.contains('"')) ? "'$sq'" : '"$sq"';
    }).toList();
    String str = lstString.toString();
    String query = str.substring(1, str.length - 1);
    String sql = '$keys VALUES($query)';
    return sql;
  }

  // updata single records
  static String updateRecordQueryBuilder(Map<String, dynamic> data) {
    List<String> select =
        data.keys.toList().map((e) => (e + " = ?, ")).toList();
    String sets = select.join();
    String subSets = sets.substring(0, sets.length - 2);
    return subSets;
  }
}
