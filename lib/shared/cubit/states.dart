abstract class AppStates {}

class InitialState extends AppStates {}

class CreateDataBaseSuccessState extends AppStates {}

class InsertToDataBaseSuccessState extends AppStates {}

class InsertToDataBaseErrorState extends AppStates {}

class GetDataFromDataBaseState extends AppStates {}

class DeleteFromDataBaseState extends AppStates {}

class AppUpdateDataState extends AppStates {}

class AppUpdateTrashDataState extends AppStates {}

class DeleteAllFromDataBaseState extends AppStates {}

class SearchLoadingState extends AppStates {}

class SearchState extends AppStates {}

class StartRecordingSuccessState extends AppStates {}

class InsertToTasksSuccessState extends AppStates {}

class InsertToTasksErrorState extends AppStates {}

class GetDataFromTasksState extends AppStates {}

class AppUpdateTasksState extends AppStates {}

class ExpandState extends AppStates {}

class AppUpdateDoneState extends AppStates {}

class DeleteFromTasksState extends AppStates {}

class DeleteAllFromTasksState extends AppStates {}

class SelectDayState extends AppStates {}
