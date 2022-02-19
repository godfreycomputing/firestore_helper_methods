import 'package:equatable/equatable.dart';

abstract class HelperExceptions extends Equatable {
  final String? code;
  final String? message;

  const HelperExceptions(this.code, this.message);

  @override
  List<Object> get props => [code ?? '', message ?? ''];
}
