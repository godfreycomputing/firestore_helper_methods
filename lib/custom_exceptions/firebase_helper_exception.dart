import 'package:equatable/equatable.dart';

abstract class FirebaseHelpersException extends Equatable {
  final String? code;
  final String? message;

  const FirebaseHelpersException(this.code, this.message);

  @override
  List<Object> get props => [code ?? '', message ?? ''];
}
