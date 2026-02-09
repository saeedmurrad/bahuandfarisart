import 'dart:ui'; // Needed for the blur effect

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

// --- MODERN FULL-SCREEN IMAGE VIEWER ---

class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final bool isAsset;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
    this.isAsset = false,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isSharing = false;
  bool _isOrientationUnlocked = false;
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _transformationController = TransformationController();
    // Start locked in portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Reset orientation preference when leaving the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _toggleOrientationLock() {
    setState(() {
      _isOrientationUnlocked = !_isOrientationUnlocked;
      if (_isOrientationUnlocked) {
        // Allow the OS to rotate to any of the 4 orientations
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      } else {
        // Lock back to portrait
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  Future<void> _onShare() async {
    setState(() {
      _isSharing = true;
    });
    try {
      final String imageUrl = widget.imageUrls[_currentIndex];
      XFile file;
      if (widget.isAsset) {
        final ByteData bytes = await rootBundle.load(imageUrl);
        file = XFile.fromData(
          bytes.buffer.asUint8List(),
          name: imageUrl.split('/').last,
          mimeType: 'image/jpeg',
        );
      } else {
        final http.Response response = await http.get(Uri.parse(imageUrl));
        file = XFile.fromData(
          response.bodyBytes,
          name: 'image.jpg',
          mimeType: 'image/jpeg',
        );
      }
      await Share.shareXFiles([file], text: 'Bahu & Faris Art Gallary');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error sharing image.')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentImageUrl = widget.imageUrls[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: widget.isAsset
                ? Image.asset(currentImageUrl, fit: BoxFit.cover)
                : Image.network(currentImageUrl, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              final imageUrl = widget.imageUrls[index];
              final key = GlobalKey();
              return InteractiveViewer(
                key: key,
                transformationController: _transformationController,
                minScale: 1.0,
                maxScale: 4.0,
                panEnabled: true,
                boundaryMargin: EdgeInsets.zero,
                onInteractionEnd: (details) {
                  _transformationController.value = Matrix4.identity();
                },
                child: Center(
                  child: widget.isAsset
                      ? Image.asset(imageUrl)
                      : Image.network(
                          imageUrl,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                ),
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _transformationController.value = Matrix4.identity();
              });
            },
          ),
          _buildFloatingUI(context),
        ],
      ),
    );
  }

  Widget _buildFloatingUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          color: Colors.black.withOpacity(0.3),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Text(
                '${_currentIndex + 1} / ${widget.imageUrls.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  _isOrientationUnlocked
                      ? Icons.screen_lock_rotation
                      : Icons.screen_rotation,
                  color: Colors.white,
                ),
                onPressed: _toggleOrientationLock,
              ),
              if (_isSharing)
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.share_outlined, color: Colors.white),
                  onPressed: _onShare,
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentIndex > 0)
                _NavigationButton(
                  icon: Icons.arrow_back_ios_new,
                  onPressed: () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                )
              else
                const SizedBox(width: 50),
              if (_currentIndex < widget.imageUrls.length - 1)
                _NavigationButton(
                  icon: Icons.arrow_forward_ios,
                  onPressed: () => _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                )
              else
                const SizedBox(width: 50),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _NavigationButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

// --- MODERN ART GALLERY SCREEN ---
class ArtGalleryScreen extends StatefulWidget {
  const ArtGalleryScreen({super.key});

  @override
  State<ArtGalleryScreen> createState() => _ArtGalleryScreenState();
}

class _ArtGalleryScreenState extends State<ArtGalleryScreen> {
  final List<String> _originalArtworks = const [
    "https://drive.google.com/uc?export=view&id=1g8Nggi0AvjghxUlHWD2Uhcm7uiWipmuC",
    "https://drive.google.com/uc?export=view&id=1FVlgSFWn6faGCK2zvPpXudBzGPliALgN",
    "https://drive.google.com/uc?export=view&id=1t_k89uX4PXtdfO3zVt5GKsl8XwGR_v0d",
    "https://drive.google.com/uc?export=view&id=1wnyTZTv5FU_QIi-Z-Q8KR0kX4-TXqh0v",
    "https://drive.google.com/uc?export=view&id=1v_iOHYbyR4mGbKWcsmIFOeQ2hyy8hjcP",
    "https://drive.google.com/uc?export=view&id=1zIAM86AZA-J1T2BwSSYfZZuf__5UARrB",
    "https://drive.google.com/uc?export=view&id=1MafhM_-Y5GjB3PWLtwrnq_5G_KWFwme4",
    "https://drive.google.com/uc?export=view&id=1VY61bM6cvqhRkJ4_6dHiNIgHMoeuCMh7",
    "https://drive.google.com/uc?export=view&id=1RYwnDmgJnIfGY0erlMbru-Bfza2s12U_",
    "https://drive.google.com/uc?export=view&id=10iLwA75SG_FMzdZ10gUdHi3g0n6Esksk",
    "https://drive.google.com/uc?export=view&id=1fWf95ehleunVh3jdnZbTn2WUOq5vNzuq",
    "https://drive.google.com/uc?export=view&id=1vQQ6aros5bRNzkxW09So_znTF9qgSjx3",
    "https://drive.google.com/uc?export=view&id=1TN00de-vyNRi1cv32UTSluUmeRuBSg0O",
    "https://drive.google.com/uc?export=view&id=10Dvqrfv92ywiOFEKPtsTEjB52cwCT_9U",
    "https://drive.google.com/uc?export=view&id=1WB62KQ05IKetCDUB_iqt8o5B8_nv_Lbv",
    "https://drive.google.com/uc?export=view&id=15ik1WRyIAeJR2tr4hkcS0d_7RIon_EuO",
    "https://drive.google.com/uc?export=view&id=1Fo_7n9lNzDnkCtvLfXw7KXehzmdxzDi-",
    "https://drive.google.com/uc?export=view&id=1oKL_Jgds6hbam-78wKWi2ecmjfojgR-v",
    "https://drive.google.com/uc?export=view&id=1s1oY7kDk6mJEhe0LqPp30Z0I8V9uPKiU",
    "https://drive.google.com/uc?export=view&id=1266b8cJ0xVdeM82nfbap3w1spJpcpcGR",
    "https://drive.google.com/uc?export=view&id=1MaXAWspiKM27-LH9Yxt7p5-ZNitlFX_A",
    "https://drive.google.com/uc?export=view&id=18fxu2uw87olAAGtGL44J-UZtXEOo7qRN",
    "https://drive.google.com/uc?export=view&id=1OhrfU3ff6ZxFoUV_Gios9OFtzXM1ZbSF",
    "https://drive.google.com/uc?export=view&id=1P-9NiuA9w122KriecdOg953T9TeItSGE",
    "https://drive.google.com/uc?export=view&id=1lmFgspKN1f1pwZv_aPVDMRG1s_Oe0sMY",
    "https://drive.google.com/uc?export=view&id=1T-xn_tnm6EnerXzd8rcqIysDu_PFCS81",
    "https://drive.google.com/uc?export=view&id=1QPoD5STHQcODDOgjQ8caJiY6oAORkZ-Q",
    "https://drive.google.com/uc?export=view&id=1Kui4OW6hBe681NmbIU99Lvxaio3NkBHx",
    "https://drive.google.com/uc?export=view&id=13LVNapqtGrzsuQjPdNV19EorL8OaUIcH",
    "https://drive.google.com/uc?export=view&id=1UX6Odb73oXNhldvuGZJ17cShUmJWn9ad",
    "https://drive.google.com/uc?export=view&id=1EVzPmTQ-TrbVqMVF_XdPbb7DVlanNTfo",
    "https://drive.google.com/uc?export=view&id=1kxbGTuaVq_RVEy88tNYtlSXtoXRYjv59",
    "https://drive.google.com/uc?export=view&id=14Wimor3Plz7VCVRyjx8KHJDicWFikmK5",
    "https://drive.google.com/uc?export=view&id=11NnjmntszH-XAYz6-PLDGsqdGCilf8Lc",
    "https://drive.google.com/uc?export=view&id=1mxo7T-03rpNJ_9X3dHAGc3oZhhtvwTdP",
    "https://drive.google.com/uc?export=view&id=1rG_nyXn4wITIL8a6jU5B8jNJpO2WMmhG",
    "https://drive.google.com/uc?export=view&id=1D720Bh-av4Hi1behZGiehU_wmmpp5Gu9",
    "https://drive.google.com/uc?export=view&id=1Av7tERlIGCc2ChpaKeVmX5-7gbkXLu2M",
    "https://drive.google.com/uc?export=view&id=1_5WHNGhVelDyakScSnojZePglusBKffj",
    "https://drive.google.com/uc?export=view&id=1h9eshSyx2Xv32G1sA1DLxpRUYexqjJCJ",
    "https://drive.google.com/uc?export=view&id=16L4C_mZ1tCDrdCOWUi4oc75EbApC6nt0",
    "https://drive.google.com/uc?export=view&id=1K_JMy6GmUbZzpnSVRdvPH1DOYBelPYey",
  ];
  late List<String> _shuffledArtworks;

  @override
  void initState() {
    super.initState();
    _shuffledArtworks = List.of(_originalArtworks)..shuffle();
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
                'Artworks',
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
                  final artworkUrl = _shuffledArtworks[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageViewer(
                            imageUrls: _shuffledArtworks,
                            initialIndex: index,
                            isAsset: false,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        artworkUrl,
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
                childCount: _shuffledArtworks.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
