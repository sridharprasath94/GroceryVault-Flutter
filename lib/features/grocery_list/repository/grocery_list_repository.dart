import 'package:fpdart/fpdart.dart';

import '../../../app/core/failure/failure.dart';
import '../domain/grocery_list.dart';

abstract class GroceryListRepository {
  Stream<Either<GroceryFailure, List<GroceryList>>> watchGroceries();

  TaskEither<GroceryFailure, Unit> addGrocery(GroceryList grocery);

  TaskEither<GroceryFailure, Unit> deleteGrocery(String id);

  TaskEither<GroceryFailure, Unit> toggleCompleted(String id);
}
