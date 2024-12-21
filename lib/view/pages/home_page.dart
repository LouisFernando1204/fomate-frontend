import 'package:flutter/material.dart';
import 'package:fomate_frontend/model/app_model.dart';
import 'package:fomate_frontend/viewmodel/timer_viewmodel.dart';
import 'package:fomate_frontend/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final viewModel = TimerViewModel();
  Map<String, bool> selectedApps = {
    'instagram': false,
    'youtube': false,
    'tiktok': false,
  };

  int timerDuration = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    viewModel.addListener(_onViewModelChange);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    viewModel.removeListener(_onViewModelChange);
    viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChange() {
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    viewModel.didChangeAppLifecycleState(state);
  }

  Future<void> _saveSelectedApps() async {
    viewModel.apps.clear();
    selectedApps.forEach((appName, isSelected) {
      if (isSelected) {
        viewModel.addApp(AppModel(name: appName, packageName: appName));
      }
    });
  }

  void _showBottomModal(BuildContext context) {
    String? selectedApp;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Social Media App",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor_1),
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedApp,
                    hint: const Text(
                      "Select an App",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: AppColors.textColor_1),
                    ),
                    items: selectedApps.keys.map((String appName) {
                      return DropdownMenuItem<String>(
                        value: appName,
                        child: Text(
                          appName[0].toUpperCase() + appName.substring(1),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: AppColors.textColor_1,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setModalState(() {
                        selectedApp = newValue;
                        selectedApps.forEach((key, value) {
                          selectedApps[key] = key == selectedApp;
                        });
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Duration (minutes)",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor_1),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setModalState(() {
                            if (timerDuration > 1) {
                              timerDuration--;
                            }
                          });
                        },
                      ),
                      Text("$timerDuration",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: AppColors.textColor_1,
                          )),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setModalState(() {
                            timerDuration++;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                      ),
                      onPressed: () async {
                        await _saveSelectedApps();
                        viewModel.setTimerDuration(timerDuration);
                        timerDuration = 5;
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Set Timer",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor_0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fomate")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
              ),
              onPressed: () => _showBottomModal(context),
              child: const Text("Arrange your schedule",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor_0)),
            ),
          ],
        ),
      ),
    );
  }
}
