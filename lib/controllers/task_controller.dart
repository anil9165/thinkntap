import 'package:get/get.dart';
import 'package:thinktap/views/task/task_view.dart';
import '../models/task.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../views/custom_widgets/custom_status.dart';

enum SortOption {
  byTitle,
  byCompletion,
}

class TaskController extends GetxController with SnackbarMixin {
  var tasks = <Task>[].obs;
  var filteredTasks = <Task>[].obs;
  var isLoading = false.obs;
  var isAdding = false.obs;
  var isDeleting = false.obs;
  var searchQuery = ''.obs;
  var page = 1.obs;
  var hasMoreTasks = true.obs;
  var sortOption = SortOption.byTitle.obs;

  ApiService apiService = ApiService();
  LocalStorageService localStorageService = LocalStorageService();

  @override
  void onInit() {
    fetchTasks();
    ever(searchQuery, (_) => filterTasks());
    ever(sortOption, (_) => sortTasks());
    super.onInit();
  }
  void fetchTasks() async {
    try {
      if (isLoading.value) return;
      isLoading(true);
      var tasksResult = await localStorageService.fetchTasks();
      if (tasksResult.isNotEmpty) {
        tasks.assignAll(tasksResult);
        filterTasks();
      }
      var apiTasksResult = await apiService.fetchTasks(page.value);
      if (apiTasksResult.isEmpty) {
        hasMoreTasks(false);
      } else {
        tasks.addAll(apiTasksResult);
        for (var task in apiTasksResult) {
          await localStorageService.insertTask(task);
        }
        page.value++; // Increment page number
        filterTasks();
      }
    } catch (e) {
      showError(
        title: 'Error',
        message: 'Failed to Load task: $e',
      );
    } finally {
      isLoading(false);
    }
  }


  void filterTasks() {
    if (searchQuery.isEmpty) {
      filteredTasks.assignAll(tasks);
    } else {
      filteredTasks.assignAll(
        tasks.where((task) => task.title.toLowerCase().contains(searchQuery.value.toLowerCase())).toList(),
      );
    }
    sortTasks();
  }

  void sortTasks() {
    filteredTasks.sort((a, b) {
      switch (sortOption.value) {
        case SortOption.byTitle:
          return a.title.compareTo(b.title);
        case SortOption.byCompletion:
        // First, sort by completion status
          if (a.completed && !b.completed) {
            return -1; // a is completed and b is not, so a should come first
          } else if (!a.completed && b.completed) {
            return 1; // a is not completed and b is, so b should come first
          } else {
            // If both have the same completion status, sort by title
            return a.title.compareTo(b.title);
          }
      }
    });
  }

  void loadMoreTasks() {
    if (isLoading.value || !hasMoreTasks.value) return;
    page.value += 1;
    fetchTasks();
  }

  void addTask(Task task) async {
    try {

      if (isAdding.value) return;
      isAdding(true);
      var addedTask = await apiService.addTask(task);
      tasks.add(addedTask);
      await localStorageService.insertTask(addedTask);
      filterTasks();
      showSuccess(
        title: 'Success',
        message: 'Add Successfully',
      );
      Get.offUntil(GetPageRoute(page: () => HomePage()), (route) => false);

    } catch (e) {
      showError(
        title: 'Error',
        message: 'Failed to add task: $e',
      );
    } finally {
      isAdding(false);
    }
  }

  void updateTask(Task task) async {
    try {
      if (isAdding.value) return;
      isAdding(true);
      await apiService.updateTask(task);
      await localStorageService.updateTask(task);
      var index = tasks.indexWhere((t) => t.id == task.id);
      tasks[index] = task;
      isAdding(false);
      showSuccess(
        title: 'Success',
        message: 'Update Successfully',
      );
      filterTasks();
      Get.offUntil(GetPageRoute(page: () => HomePage()), (route) => false);
    } catch (e) {
      showError(
        title: 'Error',
        message: 'Failed to update task: $e',
      );
    }finally{
      isAdding(false);

    }
  }
  var deletingTaskIds = <int>{}.obs;

  void deleteTask(int id) async {
    try{
      deletingTaskIds.add(id);
      await apiService.deleteTask(id);
      await localStorageService.deleteTask(id);
      tasks.removeWhere((task) => task.id == id);
      filterTasks();
      showSuccess(
        title: 'Success',
        message: 'Delete Successfully',
      );
    } catch (e) {
      showError(
        title: 'Error',
        message: 'Failed to update task: $e',
      );
    }finally {
      deletingTaskIds.remove(id);
    }
  }
}
