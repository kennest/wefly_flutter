import 'package:sembast/sembast.dart';
import 'package:weflyapps/database/app_database.dart';
import 'package:weflyapps/models/models.dart';

class ActivitiesDao {
  static const String STORE_NAME = 'activities';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _Store = intMapStoreFactory.store(STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Activite data) async {
    await _Store.add(await _db, data.toJson());
  }

  Future update(Activite data) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(data.id));
    await _Store.update(
      await _db,
      data.toJson(),
      finder: finder,
    );
  }

  Future delete(Activite data) async {
    final finder = Finder(filter: Filter.byKey(data.id));
    await _Store.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Activite>> getAllSortedByName() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('titre'),
    ]);

    final recordSnapshots = await _Store.find(
      await _db,
      finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final data = Activite.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      data.id = snapshot.key;
      return data;
    }).toList();
  }
}
