import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/product_repository.dart';
import '../models/product.dart';

abstract class ProductEvent {}

class LoadProductsEvent extends ProductEvent {}

class AddProductEvent extends ProductEvent {
  final String name;
  final int quantity;
  final DateTime? expiresAt;
  AddProductEvent(this.name, this.quantity, this.expiresAt);
}

class ProductState {
  final List<Product> products;
  final bool loading;
  ProductState({required this.products, this.loading = false});
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  ProductBloc(this.repository) : super(ProductState(products: [])) {
    on<LoadProductsEvent>(_onLoad);
    on<AddProductEvent>(_onAdd);
  }

  Future<void> _onLoad(LoadProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductState(products: state.products, loading: true));
    final products = await repository.fetchProducts();
    emit(ProductState(products: products));
  }

  Future<void> _onAdd(AddProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductState(products: state.products, loading: true));
    await repository.addProduct(event.name, event.quantity, event.expiresAt);
    add(LoadProductsEvent());
  }
}
