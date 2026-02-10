import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'art_gallery_screen.dart'; // Re-using the FullScreenImageViewer from here

class SnapsScreen extends StatefulWidget {
  const SnapsScreen({super.key});

  @override
  State<SnapsScreen> createState() => _SnapsScreenState();
}

class _SnapsScreenState extends State<SnapsScreen> {
  final List<String> _originalSnaps = const [
    "https://drive.google.com/uc?export=view&id=1Tiqrnfu6h6uQtmkKU9HnoYPR0UvnLfpB",
    "https://drive.google.com/uc?export=view&id=1U4vFMtq54XolT9IsTVaHaOk16UdG5as-",
    "https://drive.google.com/uc?export=view&id=1dOEdlZ5VQG_9NjwOIHrLey9x-OQDj-hx",
    "https://drive.google.com/uc?export=view&id=1k9B43mOMYIXUYSC-1_bXNnDLVmdqDrh6",
    "https://drive.google.com/uc?export=view&id=10rDRNPTmKono99vR_o4TPC632SxVFMdg",
    "https://drive.google.com/uc?export=view&id=1Fdi3tbvQl4G4vvmiLNyg_qNHXDolJF4u",
    "https://drive.google.com/uc?export=view&id=1FjJv_qU-qKVaf0N94BJImJTDyEyB_Uy-",
    "https://drive.google.com/uc?export=view&id=1H6l893d6etP82am61R73YNgHJ7oUoHZY",
    "https://drive.google.com/uc?export=view&id=1Zog_aOUPkSvk60fI_GwjR_2T2Fn6GpfF",
    "https://drive.google.com/uc?export=view&id=1_GtIzSrlHj5WQtwLY1Vs6vMVbgCdlUnS",
    "https://drive.google.com/uc?export=view&id=1a1COKMCfheV4sJcqNbXWN0nrvHDBBkTv",
    "https://drive.google.com/uc?export=view&id=1fvDFjhVLq4r7V2pQphKHQyqX4SK-ssLn",
    "https://drive.google.com/uc?export=view&id=1nGOpdnwp_m2o-ydCJGdDClTBmvSRsbZN",
    "https://drive.google.com/uc?export=view&id=1xoKof7UUhx9lWbDqwRo8H0jz-t6v_CXG",
    "https://drive.google.com/uc?export=view&id=1AKSksy8UCKQ8-DSounshRb39M9EA3Pox",
    "https://drive.google.com/uc?export=view&id=1BcuyctEJK2om8onfcBOBcK-zYh6ip636",
    "https://drive.google.com/uc?export=view&id=1KcMIJaT6Ezy_Jd7tTHZR_J3HAbBRwPtS",
    "https://drive.google.com/uc?export=view&id=1LHoUfRtWjp9Qj1OQA3Qecq4Xi8wVsvK9",
    "https://drive.google.com/uc?export=view&id=1Sh4gutNuZrVYO6Y6pu1t1nyzPs3X03XO",
    "https://drive.google.com/uc?export=view&id=1teLtOnZlYy5FdRIECgogVqZj6ZWxCVIK",
    "https://drive.google.com/uc?export=view&id=1xLj9W5PuLpFRURoc66TqCAZ1JC3hGi9T",
  ];
  late List<String> _shuffledSnaps;

  @override
  void initState() {
    super.initState();
    _shuffledSnaps = List.of(_originalSnaps)..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFBF8F3), // Soft off-white
              Color(0xFFF3E9E4), // Muted dusty rose
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text(
                'Snaps',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF422B22),
                ),
              ),
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Color(0xFF422B22)),
              elevation: 0,
              floating: true,
              pinned: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(12.0),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                itemBuilder: (context, index) {
                  final snapUrl = _shuffledSnaps[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageViewer(
                            imageUrls: _shuffledSnaps,
                            initialIndex: index,
                            isAsset: false,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        snapUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: const Color(0xFFD3C5BC),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF6E5B52),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                childCount: _shuffledSnaps.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
