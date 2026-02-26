import 'package:mediconnect/features/assistant/data/models/assistant_message_model.dart';

abstract class IAssistantDatasource {
  Future<AssistantMessageModel> askMedicalAssistant(String question);
}
