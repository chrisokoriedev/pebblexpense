// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

final class ApiClientProvider
    extends $FunctionalProvider<ApiClient, ApiClient, ApiClient>
    with $Provider<ApiClient> {
  ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClient create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClient>(value),
    );
  }
}

String _$apiClientHash() => r'830b3339c24d952121db45e5d7278545d0d2fbfd';

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

String _$expenseListHash() => r'4b68d3260444cdd1a16ba706b10f38e9976e7231';

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

String _$totalExpensesHash() => r'9aac467402d95912c23f8a73bb8c838fe0b69a29';
