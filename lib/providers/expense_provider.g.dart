// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExpenseList)
final expenseListProvider = ExpenseListProvider._();

final class ExpenseListProvider
    extends $AsyncNotifierProvider<ExpenseList, List<Expense>> {
  ExpenseListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseListHash();

  @$internal
  @override
  ExpenseList create() => ExpenseList();
}

String _$expenseListHash() => r'1ecbcdcedf2878dd3d9aa3a46752ec2d560a8910';

abstract class _$ExpenseList extends $AsyncNotifier<List<Expense>> {
  FutureOr<List<Expense>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Expense>>, List<Expense>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Expense>>, List<Expense>>,
              AsyncValue<List<Expense>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(totalExpenses)
final totalExpensesProvider = TotalExpensesProvider._();

final class TotalExpensesProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  TotalExpensesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalExpensesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalExpensesHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return totalExpenses(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$totalExpensesHash() => r'9be0161706a71259b1352d78c51b590153f82b5a';

@ProviderFor(expenseDetail)
final expenseDetailProvider = ExpenseDetailFamily._();

final class ExpenseDetailProvider
    extends $FunctionalProvider<AsyncValue<Expense>, Expense, FutureOr<Expense>>
    with $FutureModifier<Expense>, $FutureProvider<Expense> {
  ExpenseDetailProvider._({
    required ExpenseDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'expenseDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$expenseDetailHash();

  @override
  String toString() {
    return r'expenseDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Expense> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Expense> create(Ref ref) {
    final argument = this.argument as String;
    return expenseDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expenseDetailHash() => r'36806494d052dc30d7b4a5f3a1a4aa75bdc6e535';

final class ExpenseDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Expense>, String> {
  ExpenseDetailFamily._()
    : super(
        retry: null,
        name: r'expenseDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExpenseDetailProvider call(String id) =>
      ExpenseDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'expenseDetailProvider';
}
