
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/color.dart';
import '../../../controllers/task_controller.dart';
import '../../../models/task.dart';
import '../../custom_widgets/textform_field.dart';

class TaskForm extends StatefulWidget {
  Task? task;

  TaskForm({this.task});

  @override
  _TaskFormState createState() => _TaskFormState();
}
class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _title=TextEditingController();
  final TaskController taskController = Get.put(TaskController());

  late bool _completed;

  @override
  void initState() {
    super.initState();
    _title.text = widget.task?.title ?? '';
    _completed = widget.task?.completed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor:CustomColor.appBarColor,
        iconTheme: IconThemeData(
          color: CustomColor.white, //change your color here
        ),
        centerTitle:true,
        title: Text(widget.task == null ? ' Add Task' : 'Edit Task',style:TextStyle(color:CustomColor.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Obx(() {
            return  Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CustomTextField(
                    labelText: 'Enter Your Title',
                    controller: _title,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                    }
                  ),
                  const SizedBox(height: 10),

                  SwitchListTile(
                    title: Text('Status'),
                    value: _completed,
                    onChanged: (value) {
                      setState(() {
                        _completed = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                taskController.isAdding.value? const Center(child: CircularProgressIndicator()): ElevatedButton(
                   style:ButtonStyle(
                     fixedSize:MaterialStateProperty.all(Size(200, 40)),
                   ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Task task = Task(
                          id: widget.task?.id ?? 0,
                          title: _title.text,
                          userId:1,
                          completed: _completed,
                        );
                        TaskController taskController = Get.find();
                        if (widget.task == null) {
                          taskController.addTask(task);
                        } else {
                          taskController.updateTask(task);
                        }

                      }
                    },
                    child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
                  ),
                ],
              ),
            );
          }
          )
        ),
      ),
    );
  }
}
