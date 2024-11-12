import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:frontend/view/journal_create.dart';
import 'package:frontend/model/plant.dart';
import 'package:frontend/model/apis/plant_api.dart';
import 'package:frontend/provider/plant_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class CameraApp extends StatefulWidget {
  final Plant plant;
  final List<CameraDescription> cameras;
  const CameraApp({super.key, required this.cameras, required this.plant});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController? controller;
  XFile? imageFile; // Variable to store the captured image file
  int selectedCameraIdx = 0;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        setState(() {
          selectedCameraIdx = 0;
        });
        await _initCameraController(cameras[selectedCameraIdx]);
      } else {
        _showInSnackBar('No cameras available');
      }
    } catch (e) {
      _showInSnackBar('Error: $e');
    }
  }

  Future<void> _initCameraController(
      CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    try {
      await controller!.initialize();
    } catch (e) {
      _showInSnackBar('Camera initialization error: $e');
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue, //Colors(0XFF8E505F),
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: Text(
              'Take a picture',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Stack(
            children: <Widget>[
              if (controller != null && controller!.value.isInitialized)
                CameraPreview(controller!)
              else
                Center(
                  child: Text('Camera not available or not initialized'),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          if (controller == null ||
                              !controller!.value.isInitialized) {
                            _showInSnackBar('Error: select a camera first.');
                            return;
                          }
                          _takePicture(); // Call method to take picture
                        },
                        child: Icon(Icons.camera),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue, //Colors(0XFF8E505F),
                      ),
                      SizedBox(width: 16.0),
                      FloatingActionButton(
                        onPressed: () {
                          _onSwitchCamera(); // Call method to switch camera
                        },
                        child: Icon(Icons.switch_camera),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue, //Colors(0XFF8E505F),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Method to take a picture
  void _takePicture() async {
    if (controller == null || !controller!.value.isInitialized) {
      _showInSnackBar('Error: select a camera first.');
      return;
    }
    try {
      final XFile picture = await controller!.takePicture();
      setState(() {
        imageFile = picture;
      });
      // Navigate to the image view page after capturing the image
      if (imageFile != null) {
      Navigator.pop(context, imageFile!.path);
      } else {
	      _showInSnackBar("Error: Image capture failed.");
      }
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx = (selectedCameraIdx + 1) % cameras.length;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    _initCameraController(selectedCamera);
  }

  void _showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    _showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void _logError(String code, String? message) {
    print('Error: $code${message == null ? '' : '\nError Message: $message'}');
  }
}

class ImageViewPage extends StatefulWidget {
  final String imagePath;
  final Plant plant;
  const ImageViewPage({super.key, required this.imagePath, required this.plant});

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  bool isLoading = false;
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captured Image'),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.file(File(widget.imagePath)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await _saveImage(widget.imagePath, context);
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Icon(Icons.save),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue, //Colors(0XFF8E505F),
                  ),
                  SizedBox(width: 16.0),
                  FloatingActionButton(
                    onPressed: () async {
                      await _pickImage(this.widget.plant!);
                    },
                    child: Icon(Icons.add_a_photo),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue, //Colors(0XFF8E505F),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveImage(String imagePath, context) async {
    final result = await ImageGallerySaver.saveFile(imagePath);
    if (result == null) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image saved successfully'),
      ),
    );
    print(result);
  }

  Future<void> _pickImage(Plant plant) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
      if (this.widget.plant != null) {
	Navigator.pop(context, _imagePath);	      
      } else {
	      //add error message
	      ScaffoldMessenger.of(context).showSnackBar(
		SnackBar(
			content: Text('Error: Plant is null'),
		),
	      );
	      print("Error: Plant is null");
      }
    }
  }
}
