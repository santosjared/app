import 'package:app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class TypeComplaints extends StatelessWidget {
  TypeComplaints({super.key});

  final List<Map<String, String>> cardsData = [
    {
      "title": "Accidente de Tránsito",
      "description":
          "Es un suceso inesperado que ocurre en la vía pública y que involucra a vehículos, peatones u otros elementos relacionados con el tránsito. Este evento puede resultar en daños materiales, lesiones o incluso muertes.",
      "image": "assets/images/transito.png",
    },
    {
      "title": "Encendio",
      "description":
          "Es una combustión no controlada que se propaga en un área determinada, causando daños materiales, ambientales y, en algunos casos, pérdidas humanas. Puede ser provocado por factores naturales o por causas humanas.",
      "image": "assets/images/encendio.png",
    },
    {
      "title": "Personas en estado de ebriedad en vía pública",
      "description":
          "Las personas en estado de ebriedad en vía pública pueden representar un riesgo tanto para su seguridad como para la de los demás. La intoxicación por alcohol puede afectar la coordinación, el juicio y la capacidad de reacción, lo que puede llevar a accidentes, alteraciones del orden público o incluso actos de violencia.",
      "image": "assets/images/ebriedad.png",
    },
    {
      "title": "Persona Desaparecida",
      "description":
          "La desaparición puede ser voluntaria o involuntaria y puede estar relacionada con diversas causas, como accidentes, desorientación, secuestros, conflictos familiares o situaciones de riesgo.",
      "image": "https://via.placeholder.com/150",
    },
    {
      "title": "Riñas y peleas",
      "description":
          "Son confrontaciones físicas o verbales entre dos o más personas, generalmente originadas por desacuerdos, provocaciones o conflictos personales. Pueden ocurrir en espacios públicos o privados y, en algunos casos, derivar en lesiones o daños materiales.",
      "image": "https://via.placeholder.com/150",
    },
    {
      "title": "Robo",
      "description":
          "Es un delito que consiste en la apropiación ilegítima de un bien ajeno mediante el uso de la fuerza, violencia o intimidación. Se diferencia del hurto, que ocurre sin el uso de violencia o amenazas.",
      "image": "https://via.placeholder.com/150",
    },
    {
      "title": "Violencia",
      "description":
          "Es el uso intencional de la fuerza física, verbal o psicológica para causar daño, intimidar o someter a otra persona. Puede manifestarse en distintos ámbitos, como el familiar, escolar, social o laboral, y adoptar diversas formas, como la violencia física, emocional, sexual o económica.",
      "image": "https://via.placeholder.com/150",
    },
  ];

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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              crossAxisCount, // Aquí se ajusta el número de columnas
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: childAspectRatio / crossAxisCount,
        ),
        itemCount: cardsData.length,
        itemBuilder: (context, index) {
          var card = cardsData[index];
          String truncatedDescription = truncateText(
            card['description']!,
            card['title']!,
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
                  child: Image.asset(
                    card['image']!, // URL de la imagen
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
                    card['title']!,
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
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: CustomButton(
                    text: 'Realizar esta denuncia',
                    onPressed: () {},
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
