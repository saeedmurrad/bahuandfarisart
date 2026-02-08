import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

// --- MAIN GALLERY SCREEN ---
// This screen shows the tabs and the grid of thumbnails.

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  // --- IMAGE DATA ---
  // These lists are static. To add or remove images, you must edit the lists
  // and republish the app.
  final List<String> artGalleryImages = const [
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

  final List<String> picsGalleryImages = const [
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gallery'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Art Gallery'),
              Tab(text: 'Pics Gallery'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildGridView(context, artGalleryImages, 'Art Gallery'),
            buildGridView(context, picsGalleryImages, 'Pics Gallery'),
          ],
        ),
      ),
    );
  }

  // Helper method to build the grid of image thumbnails
  Widget buildGridView(
    BuildContext context,
    List<String> images,
    String galleryName,
  ) {
    if (images.isEmpty) {
      return Center(
        child: Text('No images found in the "$galleryName" folder.'),
      );
    }
    return GridView.builder(
      itemCount: images.length,
      padding: const EdgeInsets.all(4.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemBuilder: (context, index) {
        // Use GestureDetector to make each thumbnail tappable
        return GestureDetector(
          onTap: () {
            // When tapped, open the full-screen viewer
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenImageViewer(
                  imageUrls: images,
                  initialIndex: index,
                  galleryName: galleryName,
                ),
              ),
            );
          },
          child: Image.network(
            images[index],
            fit: BoxFit.cover,
            // Show a loading indicator for each thumbnail
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }
}

// --- FULL-SCREEN IMAGE VIEWER ---
// This screen shows one image at a time, allows swiping, has next/previous
// buttons, and a share button.

class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String galleryName;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
    required this.galleryName,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onShare() async {
    setState(() {
      _isSharing = true;
    });

    try {
      // Download the image data from the URL
      final imageUrl = widget.imageUrls[_currentIndex];
      final response = await http.get(Uri.parse(imageUrl));
      final Uint8List bytes = response.bodyBytes;

      // Create an XFile from the downloaded bytes to share the image file
      final XFile file = XFile.fromData(
        bytes,
        name: 'image.jpg',
        mimeType: 'image/jpeg',
      );

      // Use the share_plus package to show the native share sheet
      await Share.shareXFiles([file], text: 'Bahu & Faris Art Gallary');
    } catch (e) {
      // Handle potential errors, e.g., show a snackbar
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_currentIndex + 1} / ${widget.imageUrls.length}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          // Show a loading indicator while the image is being prepared for sharing
          if (_isSharing)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else
            IconButton(icon: const Icon(Icons.share), onPressed: _onShare),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // The PageView handles the main image display and swiping
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return Center(
                child: Image.network(
                  widget.imageUrls[index],
                  // Show a loading indicator while the full-res image loads
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),

          // --- NAVIGATION BUTTONS ---
          // Previous Button
          if (_currentIndex > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          // Next Button
          if (_currentIndex < widget.imageUrls.length - 1)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
