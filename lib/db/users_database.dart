import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:project/model/user.dart';
import 'package:project/model/problem.dart';
import 'package:project/model/allergy.dart';

class UsersDatabase {
  static final UsersDatabase instance = UsersDatabase._init();

  static Database _database;

  UsersDatabase._init();

  //open connection
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('users.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final intType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableUsers(
      ${UserFields.id} $idType,
      ${UserFields.name} $textType,
      ${UserFields.surname} $textType,
      ${UserFields.birthdate} $textType,
      ${UserFields.gender} $textType,
      ${UserFields.weight} $intType,
      ${UserFields.username} $textType,
      ${UserFields.password} $textType,
      ${UserFields.email} $textType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableProblems(
      ${ProblemFields.id} $idType,
      ${ProblemFields.user_id} $intType,
      ${ProblemFields.problem} $textType,
      ${ProblemFields.date} $textType,
      ${ProblemFields.scale} $textType,
      FOREIGN KEY(${ProblemFields.user_id}) REFERENCES ${UserFields.id}
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableAllergies(
      ${AllergyFields.id} $idType,
      ${AllergyFields.user_id} $intType,
      ${AllergyFields.allergy} $textType,
      ${AllergyFields.image} $textType,
      FOREIGN KEY(${AllergyFields.user_id}) REFERENCES ${UserFields.id}
    )
    ''');
  }

  Future<List<Map<String, dynamic>>> getData(table) async {
    final db = await instance.database;
    return db.query(table); //επιστρεφει μια λιστα απο maps
  }

  Future<User> create(User user) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.name},${NoteFields.surname},${NoteFields.birthdate},${NoteFields.gender},${NoteFields.weight},${NoteFields.username},${NoteFields.password},${NoteFields.email}';
    // final values =
    //     '${json[NoteFields.name]},${json[NoteFields.surname]},${json[NoteFields.birthdate]},${json[NoteFields.gender]},${json[NoteFields.weight]},${json[NoteFields.username]},${json[NoteFields.password]},${json[NoteFields.email]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableUsers, user.toMap());
    return user.copy(id: id);
  }

  Future<Problem> createProblem(Problem problem) async {
    final db = await instance.database;

    final id = await db.insert(tableProblems, problem.toMap());
    return problem.copy(id: id);
  }

  Future<Allergy> createAllergy(Allergy allergy) async {
    final db = await instance.database;

    final id = await db.insert(tableAllergies, allergy.toMap());
    return allergy.copy(id: id);
  }

  Future<User> readUser(String username, String password) async {
    final db = await instance.database;

    final maps = await db.query(
      tableUsers,
      columns: UserFields.values,
      //prevent sql injection
      where: '${UserFields.username} = ? AND ${UserFields.password} = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      print("User $username not found");
      return null;
    }
  }

  Future<bool> checkUsernameExistence(String username) async {
    final db = await instance.database;

    final maps = await db.query(tableUsers,
        columns: UserFields.values,
        where: '${UserFields.username} = ?',
        whereArgs: [username]);

    if (maps.isNotEmpty) {
      //exists
      return Future<bool>.value(true);
    } else
      //not
      return Future<bool>.value(false);
  }

  Future<int> update(User user) async {
    final db = await instance.database;

    return db.update(
      tableUsers,
      user.toMap(),
      where: '${UserFields.id} = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableUsers,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
