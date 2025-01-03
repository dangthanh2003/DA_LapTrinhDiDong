import 'package:flutter/material.dart';
import 'tour_detail_page.dart';
import '../models/tour.dart';
import '../services/tour_service.dart';

class TourListPage extends StatefulWidget {
  const TourListPage({super.key});

  @override
  _TourListPageState createState() => _TourListPageState();
}

class _TourListPageState extends State<TourListPage> {
  List<Tour> tours = []; // A list to hold the tour objects
  bool isLoading = true; // To show loading indicator while fetching data
  String? errorMessage; // To store error message if there is an error

  // Khởi tạo ApiService
  final ApiService apiService = ApiService();

  // Fetch tours from the API
  Future<void> fetchTours() async {
    try {
      final fetchedTours = await apiService.fetchTours(); // Gọi hàm fetchTours từ ApiService
      setState(() {
        tours = fetchedTours;
        isLoading = false;
        errorMessage = null;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = error.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTours(); // Fetch the tours when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Các tour du lịch mới nhất',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator()) // Hiển thị khi đang tải
                : errorMessage != null
                ? Center(
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ) // Hiển thị thông báo lỗi nếu có lỗi
                : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1,
              ),
              itemCount: tours.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to TourDetailPage and pass the selected tour object
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TourDetailPage(tourId: tours[index].tourId),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 4.0,
                    child: Column(
                      children: [
                        // Display tour image
                        AspectRatio(
                          aspectRatio: 16 / 9, // AspectRatio 16:9 để hiển thị hình ảnh đúng tỉ lệ
                          child: Image.asset(
                            'assets/images${tours[index].img.toLowerCase().replaceAll(' ', '_')}',
                            fit: BoxFit.cover, // Hình ảnh vừa khít với container
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            tours[index].tourName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
