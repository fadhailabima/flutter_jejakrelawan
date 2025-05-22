import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:my_flutter_app/services/event_services.dart';
import 'package:intl/intl.dart';
import 'package:my_flutter_app/submission_success_screen.dart';

class IsiLaporanScreen extends StatefulWidget {
  final int eventId;

  const IsiLaporanScreen({super.key, required this.eventId});

  @override
  State<IsiLaporanScreen> createState() => _IsiLaporanScreenState();
}

class _IsiLaporanScreenState extends State<IsiLaporanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contributionController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  late Future<Map<String, dynamic>> _eventDetails;
  String baseUrl = 'http://localhost:8080/api/file/';
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _eventDetails = fetchEventDetails();
    _contributionController.addListener(_updateButtonState);
    _feedbackController.addListener(_updateButtonState);
  }

  Future<Map<String, dynamic>> fetchEventDetails() async {
    final eventServices = EventServices();
    return await eventServices.fetchEventById(widget.eventId);
  }

  String getImagePath(String imageUrl) {
    return imageUrl.isNotEmpty ? imageUrl.split('/').last : '';
  }

  String getFullImageUrl(String imageUrl) {
    final imagePath = getImagePath(imageUrl);
    return imagePath.isNotEmpty ? '$baseUrl$imagePath' : '';
  }

  File? photo;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        photo = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _contributionController.removeListener(_updateButtonState);
    _feedbackController.removeListener(_updateButtonState);
    _contributionController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _contributionController.text.isNotEmpty &&
          _feedbackController.text.isNotEmpty;
    });
  }

  Future<void> _submitReport() async {
    final eventServices = EventServices();
    final reportData = {
      'contribution': _contributionController.text,
      'feedback': _feedbackController.text,
    };

    try {
      await eventServices.createReport(
        widget.eventId,
        reportData,
        photo?.path,
      );
      _formKey.currentState!.reset();
      _contributionController.clear();
      _feedbackController.clear();
      setState(() {
        photo = null;
      });
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SubmissionSuccessScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim laporan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Laporan & Evaluasi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<Map<String, dynamic>>(
                future: _eventDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final event = snapshot.data!;
                    final imageUrl = getFullImageUrl(event['image_url']);
                    final title = event['title'];
                    final location = event['location'];
                    final startDate = event['start_date'];
                    final parsedDate = DateTime.parse(startDate);
                    final formattedDate =
                        DateFormat('d MMMM yyyy').format(parsedDate);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 200,
                                color: Colors.grey,
                                child: const Icon(Icons.broken_image, size: 50),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$location\n$formattedDate',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  } else {
                    return const Text('No event data found');
                  }
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Ceritakan kontribusimu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contributionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Ceritakan kontribusimu',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 12,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kolom ini tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Foto dokumentasi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                    image: photo != null
                        ? DecorationImage(
                            image: FileImage(photo!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: photo == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_rounded,
                                  size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'Unggah foto dokumentasi',
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Feedback untuk penyelenggara',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _feedbackController,
                decoration: const InputDecoration(
                  hintText: 'Feedback untuk penyelenggara',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled
                        ? const Color.fromRGBO(7, 122, 255, 1)
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: _isButtonEnabled ? _submitReport : null,
                  child: const Text(
                    'Kirim',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
