import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/saree_provider.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _fabricController = TextEditingController();
  final _colorController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoryController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _image != null) {
      await Provider.of<SareeProvider>(context, listen: false)
          .addSaree(
            name: _nameController.text,
            price: _priceController.text,
            fabric: _fabricController.text,
            color: _colorController.text,
            stock: _stockController.text,
            category: _categoryController.text,
            image: _image!,
          );
      
       Navigator.pop(context);
    } else if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4A0404); // Deep Maroon
    const accentColor = Color(0xFFD4AF37); // Royal Gold

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload New Saree',
          style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold, color: accentColor),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: accentColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: accentColor.withOpacity(0.3)),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                            const SizedBox(height: 10),
                            Text('Tap to select image',
                                style: GoogleFonts.inter(color: Colors.grey)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(_nameController, "Saree Name/Code", "e.g., Banarasi Silk 01"),
              _buildTextField(_priceController, "Price", "e.g., 2500", keyboardType: TextInputType.number),
              _buildTextField(_fabricController, "Fabric Type", "e.g., Pure Silk, Chiffon"),
              _buildTextField(_colorController, "Color", "e.g., Maroon, Cream"),
              _buildTextField(_stockController, "Stock Quantity", "e.g., 50", keyboardType: TextInputType.number),
              _buildTextField(_categoryController, "Category", "e.g., Daily Wear, Wedding"),
              const SizedBox(height: 30),
               ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  'UPLOAD NOW',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: accentColor,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
          ),
        ),
      ),
    );
  }
}
