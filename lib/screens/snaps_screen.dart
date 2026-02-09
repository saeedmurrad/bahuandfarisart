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
    "https://drive.google.com/uc?export=view&id=1_hqV4rDf366xQZPg3FLbcFkn0NGBqYZY",
    "https://drive.google.com/uc?export=view&id=1uS6nhkIDYdOYJ_IffHGApjYnq_ssBM3Y",
    "https://drive.google.com/uc?export=view&id=1f-uNBElPGhPrbTao7z_1n41cYUclHEDg",
    "https://drive.google.com/uc?export=view&id=1vlDPyuHKwMeO1Y736dDr_RKqViLyWu4C",
    "https://drive.google.com/uc?export=view&id=1j6aE9E33h8c7Rx8QPr_8Avbek7pacv0I",
    "https://drive.google.com/uc?export=view&id=1ieq-_L1HxUIqSrUsVF8gTq6_gQo25ZPe",
    "https://drive.google.com/uc?export=view&id=1pW9b5ga_C-9JyTZrwou1vyIozPZ_IkTM",
    "https://drive.google.com/uc?export=view&id=11mJ2pBBRHOWphwi6IjFwWLP4kzqamxCw",
    "https://drive.google.com/uc?export=view&id=1fIE2hrdlCDJwFIq88QXLnCnEdNdCIIUg",
    "https://drive.google.com/uc?export=view&id=1xmRh6HwcCwWJzFRMhm9ptGk-0YqVEezH",
    "https://drive.google.com/uc?export=view&id=1nmYv7BtEVgpY3KS0As8CWGJaiqwSpdzF",
    "https://drive.google.com/uc?export=view&id=1RJdS2b390M5hPOFByo0b8t1UTE2DDs3C",
    "https://drive.google.com/uc?export=view&id=1do3tpJa5JY5n2ZeW9Lcqs22wnd_NErad",
    "https://drive.google.com/uc?export=view&id=1T8uUAj6OzDw86n_BGigRtNjY-U27Dg7j",
    "https://drive.google.com/uc?export=view&id=1npD996Daot8eEUb5AlOwT8bKeePn4JB1",
    "https://drive.google.com/uc?export=view&id=1HNLTNgbL-zoLVF2JoIw-Ruu4mGAM5VSZ",
    "https://drive.google.com/uc?export=view&id=17EDF6Uoq3pBeRHEfKtYVuOQCIOoZ_rBz",
    "https://drive.google.com/uc?export=view&id=1XCL_9NTLnyMjq69hq83OM04Oew3yuTSx",
    "https://drive.google.com/uc?export=view&id=1xkCAIaxAMRtasbTe78bI2N_Svd5jIpcB",
    "https://drive.google.com/uc?export=view&id=1-ZTgVytZ17XsNukiMCCZYI8qxT4Hfyxh",
    "https://drive.google.com/uc?export=view&id=1xHhQuqwyKIdA1nPaDhoFXD-7YNDpj74T",
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
