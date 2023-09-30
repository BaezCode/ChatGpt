import 'package:chat_gpt/models/chat_response.dart';
import 'package:chat_gpt/shared/preferencias_usuario.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'conversaciones_event.dart';
part 'conversaciones_state.dart';

class ConversacionesBloc
    extends HydratedBloc<ConversacionesEvent, ConversacionesState> {
  final prefs = PreferenciasUsuario();
  List<ChatResponse> folders = [];
  ConversacionesBloc() : super(ConversacionesState()) {
    on<SetListConv>((event, emit) {
      emit(state.copyWith(conversaciones: event.conversaciones));
    });
    on<SetuidConv>((event, emit) {
      emit(state.copyWith(uidConv: event.uidConv));
    });
  }

  void updateConv(String msg, String lastMsg) {
    final index = state.conversaciones
        .indexWhere((element) => element.uid == state.uidConv);
    state.conversaciones[index].lastMsg = lastMsg;
    state.conversaciones[index].msg = msg;
    add(SetListConv(state.conversaciones));
  }

  @override
  ConversacionesState? fromJson(Map<String, dynamic> json) {
    try {
      final lista = List<ChatResponse>.from(
          json["reciente"].map((x) => ChatResponse.fromJson(x)));
      final uid = json['convUID'];
      return ConversacionesState(
          conversaciones: lista, uidConv: uid.toString());
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ConversacionesState state) {
    return {'reciente': state.conversaciones, 'convUID': state.uidConv};
  }
}
