import 'package:app/config/env_config.dart';
import 'package:app/models/complaints_model.dart';
import 'package:app/services/complaints_service.dart';
import 'package:flutter/material.dart';

class TypeComplaints extends StatefulWidget {
  const TypeComplaints({super.key});

  @override
  State<TypeComplaints> createState() => _TypeComplaints();
}

class _TypeComplaints extends State<TypeComplaints> {
  final ComplaintsService complaintsService = ComplaintsService();
  List<ComplaintsModel> typeComplaints = [];

  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  _loadComplaints() async {
    final List<ComplaintsModel> fetchComplaints =
        await complaintsService.getComplaints();
    if (mounted) {
      setState(() {
        typeComplaints = fetchComplaints;
        _loading = false;
      });
    }
  }

  String truncateText(String text, String title, int maxLength) {
    if (text.length + title.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double childAspectRatio = (screenWidth * 0.22) / 100;
    int crossAxisCount;
    if (screenWidth < 600) {
      crossAxisCount = 1;
    } else if (screenWidth < 1200) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 4;
    }

    return _loading
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator()],
          ),
        )
        : Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: childAspectRatio / crossAxisCount,
            ),
            itemCount: typeComplaints.length,
            itemBuilder: (context, index) {
              var card = typeComplaints[index];
              String truncatedDescription = truncateText(
                card.description,
                card.name,
                180,
              );
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        '${EnvConfig.apiUrl}/images/${card.image}',
                        width: double.infinity,
                        height: 210,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 210,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 50),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        card.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        truncatedDescription,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        child: Text('Realizar esta denuncia'),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/complaints',
                            arguments: card,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
  }
}
