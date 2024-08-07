
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:thinktap/constants/color.dart';
import 'package:thinktap/controllers/task_controller.dart';
import 'package:thinktap/views/task/widgets/task_form.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController taskController = Get.put(TaskController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        taskController.loadMoreTasks(); // Trigger load more tasks
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:CustomColor.appBarColor,
        title: const Text('ThinkNtap Task',style:TextStyle(            color: CustomColor.white,
        ),),
        actions: [
          PopupMenuButton<SortOption>(
            iconColor:CustomColor.white,
            onSelected: (SortOption result) {
              taskController.sortOption(result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(
                value: SortOption.byTitle,
                child: Text('Sort by Title'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.byCompletion,
                child: Text('Sort by Completion'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                isDense:true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                taskController.searchQuery(value);
              },
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                    taskController.hasMoreTasks.value &&
                    !taskController.isLoading.value) {
                  taskController.loadMoreTasks();
                }
                return true;
              },
              child: Obx(() {
                if (taskController.isLoading.value && taskController.tasks.isEmpty) {
                  return  const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: taskController.filteredTasks.length,
                  padding:const EdgeInsets.all(4),
                  itemBuilder: (context, index) {
                    print("taskController.tasks.length---${taskController.tasks.length}");
                    print("taskController.tasks.length---${index}");
                    if (index == taskController.tasks.length-1) {
                      print("hbfhdfdfhfd");
                      return taskController.hasMoreTasks.value
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink(); // No more tasks to load
                    }
                    final task = taskController.filteredTasks[index];
                    return Card(
                      elevation:1,
                      margin:const EdgeInsets.all(4),
                      child: Column(
                        children: [
                          ListTile(
                            title: Container(
                                child: Text(
                                    task.title,
                                  maxLines:2,
                                  overflow:TextOverflow.ellipsis,
                                )),
                            trailing: task.completed?const Text(
                                "Completed",
                              style:TextStyle(color:CustomColor.successColor),
                            ):const Text("Incomplete",
                              style:TextStyle(color:CustomColor.errorColor),
                            ),
                            onTap: () {
                              Get.to(() => TaskForm(task: task));
                            },
                            onLongPress: () {
                              taskController.deleteTask(task.id);
                            },
                          ),
                           Obx( () {
                               return Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.to(() => TaskForm(task: task));
                                      },
                                      child: const Text('Update Task'),
                                    ),
                                    taskController.deletingTaskIds.contains(task.id)?const Center(child: CircularProgressIndicator()):
                                    ElevatedButton(
                                      onPressed: () {
                                        taskController.deleteTask(task.id);
                                      },
                                      child: const Text('Delete Task'),
                                    ),

                                  ],
                                                           ),
                               );
                             }
                           ),
                        ],
                      ),
                    );
                    },
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TaskForm()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

}

