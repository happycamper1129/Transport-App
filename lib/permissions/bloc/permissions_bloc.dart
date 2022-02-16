// Dart imports:
import 'dart:async';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  PermissionsBloc() : super(PermissionsInitial()) {
    on<PermissionsLocationRequested>(_requestLocationPermission);
    on<PermissionsPhoneStateRequested>(_requestPhoneStatePermission);
  }

  Future<void> _requestLocationPermission(
    PermissionsLocationRequested event,
    Emitter<PermissionsState> emit,
  ) async {
    const permission = Permission.locationWhenInUse;

    final status = await permission.request();

    emit(
      PermissionsStatusChange(
        permission: permission,
        status: status,
      ),
    );
  }

  Future<void> _requestPhoneStatePermission(
    PermissionsPhoneStateRequested event,
    Emitter<PermissionsState> emit,
  ) async {
    const permission = Permission.phone;

    final status = await permission.request();

    emit(
      PermissionsStatusChange(
        permission: permission,
        status: status,
      ),
    );
  }
}
