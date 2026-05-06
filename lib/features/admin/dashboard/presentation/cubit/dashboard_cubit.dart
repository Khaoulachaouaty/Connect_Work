import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/dashboard_service.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardService _dashboardService;

  DashboardCubit(this._dashboardService) : super(DashboardInitial());

  Future<void> loadStats() async {
    emit(DashboardLoading());
    try {
      final stats = await _dashboardService.getStats();
      emit(DashboardLoaded(stats));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}