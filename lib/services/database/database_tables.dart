class DataBaseTable {
  static String userTable = '''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cnic TEXT NOT NULL,
        age TEXT NOT NULL,
        address TEXT,
        country TEXT,
        city TEXT,
        updatedDate INTEGER NOT NULL,
        createdDate INTEGER NOT NULL
      )
      ''';
}
