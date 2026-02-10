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
  int rotationIndex = 0;

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

  void rotateImageClockwise() {
    setState(() {
      rotationIndex = (rotationIndex + 1) % 4;
    });
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

  /*
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


 */
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
                  child: AnimatedRotation(
                    turns: rotationIndex / 4, // 👈 USE rotationIndex HERE
                    duration: const Duration(milliseconds: 300),
                    child: widget.isAsset
                        ? Image.asset(imageUrl)
                        : Image.network(
                            imageUrl,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const CircularProgressIndicator(
                                color: Colors.white,
                              );
                            },
                          ),
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
              /*
              IconButton(
                icon: Icon(
                  _isOrientationUnlocked
                      ? Icons.screen_lock_rotation
                      : Icons.screen_rotation,
                  color: Colors.white,
                ),
                onPressed: _toggleOrientationLock,
              ),


               */
              IconButton(
                icon: const Icon(Icons.screen_rotation, color: Colors.white),
                onPressed: rotateImageClockwise,
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
    "https://drive.google.com/uc?export=view&id=1tcl4TSfIr59QGIZxo4i_EiULWbI8jT0V",
    "https://drive.google.com/uc?export=view&id=18wpsvc_BJt3HeSZujUddImOxFVxGdaC1",
    "https://drive.google.com/uc?export=view&id=1BA2vg2m8DefrLa7J20hLTj4AFQL5u83n",
    "https://drive.google.com/uc?export=view&id=1tmvOwwiXS5Ydk0ewUyWFMRtTYZTKKgoQ",
    "https://drive.google.com/uc?export=view&id=1EmXAEGzFZrVEzUxup4IbewGSCGfiI4Wu",
    "https://drive.google.com/uc?export=view&id=1a-8yS6pI_KsMUY5iz5Qej7RlFcXIrYxf",
    "https://drive.google.com/uc?export=view&id=1z2-2ekbAf9SVjMsIa-GR7O8hrV3sV7gL",
    "https://drive.google.com/uc?export=view&id=1WQ8xOmnXt0oDXWm3hzQt0-s4MYbGnx9X",
    "https://drive.google.com/uc?export=view&id=1JTcvPNZ8DApTMOKoxzQT11POpSY-E_iJ",
    "https://drive.google.com/uc?export=view&id=1kysrXYv_3Mhk7Zae5-uIC-HQ1-QLP8cL",
    "https://drive.google.com/uc?export=view&id=1isXM22SIbBFFwMPJGx-3fYvgmn6dNScj",
    "https://drive.google.com/uc?export=view&id=119qoNjL9MnJBIH06e7L_QttXKSBGtXkA",
    "https://drive.google.com/uc?export=view&id=1bgdONtDSTAJUkj2exggCv2-EtPoxgS6O",
    "https://drive.google.com/uc?export=view&id=1d7_999-AGXNG8ETvqSgwIuvy9DYvI_3X",
    "https://drive.google.com/uc?export=view&id=15jYeKy3aJ0nlsBbHeBg0Wldj5SvU9vZI",
    "https://drive.google.com/uc?export=view&id=13clrRdz4cYdnPeV5D0QfsRs_lFe59XHz",
    "https://drive.google.com/uc?export=view&id=12f24ABjPoiky8rXiWFKBmkzWyBlGZs2w",
    "https://drive.google.com/uc?export=view&id=1oKQ5EORGRZRKCaW9plFebVxfBgvANpg9",
    "https://drive.google.com/uc?export=view&id=19_zT_cZmSsBJ_QqSlp191EOS8ipMM4_P",
    "https://drive.google.com/uc?export=view&id=1tbNCXCJcG4NfLkY-GVl2lcRYJ66ajaNv",
    "https://drive.google.com/uc?export=view&id=1jY8GWgpkC7ybjgxPAokZArmDCMSIS0Fx",
    "https://drive.google.com/uc?export=view&id=1DadN3H_-JHgVgu2XBv4WANOYWM1YZvWN",
    "https://drive.google.com/uc?export=view&id=11n0cwIwVewEnXOYCkeG_IsPyA6epY4vf",
    "https://drive.google.com/uc?export=view&id=1q5mL65Z5svvBTVjVKDxMw22omw7RcEQo",
    "https://drive.google.com/uc?export=view&id=1CrEsdc-okNb_5tzAEEdR1d7DEaBTMJY4",
    "https://drive.google.com/uc?export=view&id=1CAEybrTC9PJIg7STgEh5NwfdI3gMfx41",
    "https://drive.google.com/uc?export=view&id=1GKigF-Sa8p5K0SQ1j4VrNcxwFrP-T3pC",
    "https://drive.google.com/uc?export=view&id=1D9WjciprODS1TO1O8wU9P10uQQ5PDoLP",
    "https://drive.google.com/uc?export=view&id=1So7hOI6Mq8UAxdv2Tpm4UXbF1uvmYXm0",
    "https://drive.google.com/uc?export=view&id=1tbaee_gmcZwY-Ba-3KXwT8tbs-BaRh7t",
    "https://drive.google.com/uc?export=view&id=19ZIy_khqeczB8AJ_1W87R7sJYaa2N8F2",
    "https://drive.google.com/uc?export=view&id=1_mLtnNlJNOtxHasuH_22LVPIK5aZXxGZ",
    "https://drive.google.com/uc?export=view&id=1QoeAwyipYAj6Uh7BLiztlca-6_ygcqH1",
    "https://drive.google.com/uc?export=view&id=1yZjYWDbMU2_GdL_1Q45zNSch5N3UIpKc",
    "https://drive.google.com/uc?export=view&id=1Q7jmPdmtf7uG8FjN7-dRWwYjDW181qss",
    "https://drive.google.com/uc?export=view&id=1ljT9Us164uJKdYuOZG4TipNHFgfzuahb",
    "https://drive.google.com/uc?export=view&id=188YVJhgIYOzmSPxD5CGASJ2kQuro8JFq",
    "https://drive.google.com/uc?export=view&id=1_6A-E-mnpg0CWQeUHL_D2AvdcGVaNrp2",
    "https://drive.google.com/uc?export=view&id=11udgQzRv2XNDztGxW9pocxHKTL3Wc5pG",
    "https://drive.google.com/uc?export=view&id=1P4BgB6aRAwDWLDjHm6bRwDbX0gtBPsoq",
    "https://drive.google.com/uc?export=view&id=1goF4_qpI4xzxCOmlxPguObRtL08yDEXQ",
    "https://drive.google.com/uc?export=view&id=1vCsHUy7oAMNGDO054P-gSTysrcGAAUjI",
    "https://drive.google.com/uc?export=view&id=1mqhDDJ6xYVahMRajWiQppsDd-oCSfIuI",
    "https://drive.google.com/uc?export=view&id=1j7ZY-okW09BE4CBuVBJVzI6MBIQSQbGT",
    "https://drive.google.com/uc?export=view&id=10X6e96D9PByTR2KksgLiQ1FLgcAsfvFP",
    "https://drive.google.com/uc?export=view&id=17-838QVE2Nye0y3KuR5sIV_d8KDh1zNj",
    "https://drive.google.com/uc?export=view&id=1ZxxD8Sivyh3HrALyNiUQEYPLHxchYYHE",
    "https://drive.google.com/uc?export=view&id=19KEgImuQ5Ltu-FrNAMzOygDhgUPs4MuO",
    "https://drive.google.com/uc?export=view&id=1w3ABpn-_KoJZMT-_bDwR45ZdipwL2U0F",
    "https://drive.google.com/uc?export=view&id=179cTNNIYO1I08jM0XHq7jfmRTUQX2m5g",
    "https://drive.google.com/uc?export=view&id=19m86Ts1mwn1lg7uwMh1ZJ4fY6Jh1mgpI",
    "https://drive.google.com/uc?export=view&id=1PFuQnZjtmEHtDc51A4sp04dvB-XN9UKg",
    "https://drive.google.com/uc?export=view&id=1p5Lfb30lUT_LPG3eFjKSZw_qnhDSjoBb",
    "https://drive.google.com/uc?export=view&id=1cjEUX1s4ZsMs8xNOygOEXzwtzwse2q5N",
    "https://drive.google.com/uc?export=view&id=12SRrOxj1rL1iStJvg2BosepIqN4lhVL4",
    "https://drive.google.com/uc?export=view&id=1SnTVzZ32czvaAhPN7UE5ZrBS3s7ZJWwo",
    "https://drive.google.com/uc?export=view&id=1bO7dgXHRwi-S_69fKYqfHAC5HqlCcKE8",
    "https://drive.google.com/uc?export=view&id=1r6o2wUSSc2qd06YjYjdM-7E_kmmvIQGH",
    "https://drive.google.com/uc?export=view&id=1zXSWM-AUsGK2_Jz2P_tV3aYojk8ktPzO",
    "https://drive.google.com/uc?export=view&id=1wfkyD-vcMXRHGNc4QFF5TaAgQ6ip4Lik",
    "https://drive.google.com/uc?export=view&id=1jj2AnhxkPURhlSZTaRyWz8a9a3fjTbBD",
    "https://drive.google.com/uc?export=view&id=1s9HEDpxv2NabDUWkiZ1YM3eKBoYvc0go",
    "https://drive.google.com/uc?export=view&id=14YaOSfoPUU1gOC2GTo96qdYXhG76E_4d",
    "https://drive.google.com/uc?export=view&id=1b7DCYdA8lwH1Cq2Oo5awmwm7X7lIsYO-",
    "https://drive.google.com/uc?export=view&id=1GuZnRp7z9p-LKCCEZAiRwRTINhYE2nrY",
    "https://drive.google.com/uc?export=view&id=1TXAAnpc4wTAkBNpt5A1WExjjyg1aTjDw",
    "https://drive.google.com/uc?export=view&id=1Vqqs2qUsGJm6zL1VLPC9Wb0FEzjF7zJn",
    "https://drive.google.com/uc?export=view&id=1UE-aa6bA7o45Pyh364Sv5I4NL6jiiqvl",
    "https://drive.google.com/uc?export=view&id=1s6yKxzFYIyoy33HecztgjwNJIr_-WZsG",
    "https://drive.google.com/uc?export=view&id=1Nt4pDPUXkiaauuulVL1BpSliNZO68vbB",
    "https://drive.google.com/uc?export=view&id=1dQx2AIeBK-EEBXah_vxa8Lf54AeY8bO-",
    "https://drive.google.com/uc?export=view&id=1zNrVcWpWAVVyaZ7X0QpGlYYDERx9MQZx",
    "https://drive.google.com/uc?export=view&id=1kf9g3W90NRvhPLYNUIWTBNuFXRnjWMr9",
    "https://drive.google.com/uc?export=view&id=1l4i7nGMML9i9tNfiRc9SeuJxOkAsY1i9",
    "https://drive.google.com/uc?export=view&id=1Jb0O_CidNh1kVQhjq03P2EOpyrxPWMxo",
    "https://drive.google.com/uc?export=view&id=1klsZuHKcakbD0Ibr2Y1QuBPgoEuvv8Hy",
    "https://drive.google.com/uc?export=view&id=1ybAciw4iO14fmo11n_XcME7drdK5qrIF",
    "https://drive.google.com/uc?export=view&id=1lHVHdqlkTQWJQ0gAnzUFzGSQDTUrrNil",
    "https://drive.google.com/uc?export=view&id=1O-HtpHCoDyMd_fsuFX0AhbWgj5iL2L43",
    "https://drive.google.com/uc?export=view&id=1NXX77m9Ar7vCXYYX9eRubPKZeg9VuMyL",
    "https://drive.google.com/uc?export=view&id=1-7zw9p-YkRY3UEdRuRP630Snzd_mbN-r",
    "https://drive.google.com/uc?export=view&id=1weIyXDL2KZO4ZKVaaf39e4ztHHoVN28M",
    "https://drive.google.com/uc?export=view&id=14Ly8mGV1BIGVBKCk55XfDCW8an6Ywdt5",
    "https://drive.google.com/uc?export=view&id=1SUOT1p3ImmeHAkBoLkYVRzAn1EqlYJW1",
    "https://drive.google.com/uc?export=view&id=1vvQulSGE_ErJyLb0t6iM5OIMwMvkUGGn",
    "https://drive.google.com/uc?export=view&id=18Q57bIXpsvgwpmVQUubG6OoWbQHCLnRL",
    "https://drive.google.com/uc?export=view&id=1nFpopuJf4u4yyIwOncpDy4ha8J1yeGe5",
    "https://drive.google.com/uc?export=view&id=1eTsUtfJD7-nG-7UyifENfcMT3vxb2zQm",
    "https://drive.google.com/uc?export=view&id=1I-GKdIxcPmtcPIORrU1AiKS6ulYjkue6",
    "https://drive.google.com/uc?export=view&id=1Zi7snRvCUcOzLCvOUmO91xv2XuALik43",
    "https://drive.google.com/uc?export=view&id=18uxMc2ei7XpichSbsfak44EqxS9yx4TL",
    "https://drive.google.com/uc?export=view&id=1SAtTEgNIiWi7lpwzDP07MQLechbXGqbF",
    "https://drive.google.com/uc?export=view&id=1u7EO8TubesNkoojrmwPj6uAWZ56I_FPb",
    "https://drive.google.com/uc?export=view&id=1pUF5MhdRfk3646YNdtjzP_meBL6rT_ek",
    "https://drive.google.com/uc?export=view&id=1hashWBnWKRlel1k1Y_Iuorsp3CzukeU7",
    "https://drive.google.com/uc?export=view&id=1OWWS6i8m0I0K145avuYUaie6at0o7AcW",
    "https://drive.google.com/uc?export=view&id=1vVmHAkM9_GlPLDAVSn9gzKZnhKUcL_ne",
    "https://drive.google.com/uc?export=view&id=1XUZvJAqPTGnc9XTBAE-cQG_09hepNa0Z",
    "https://drive.google.com/uc?export=view&id=1h919RFuRVdoNitKiYShrTlqTmfT7fNwh",
    "https://drive.google.com/uc?export=view&id=10b1FjiM83Hu8Imz1uMaBCc_zCL6U26HF",
    "https://drive.google.com/uc?export=view&id=1wsDp24PUXmW_QvvTaYUf0H4JwRSmw-Jy",
    "https://drive.google.com/uc?export=view&id=1CZ5ak7kFrDIpRAVvjOXoz90lOT53xXoC",
    "https://drive.google.com/uc?export=view&id=1oFN18PHlh2BTHpBV8mo2cPw0ftJ6LzwL",
    "https://drive.google.com/uc?export=view&id=1lljN1Q64Xaie5cY03rsEcu-jxcSa73zK",
    "https://drive.google.com/uc?export=view&id=1_C6bcMjqQQHT9bSKTO6tKHHi4UdcfzKU",
    "https://drive.google.com/uc?export=view&id=1b2wzlYDC6FMjifL0Z1kKzW49-JTsfKD0",
    "https://drive.google.com/uc?export=view&id=1SZy6zdTz_8LnIqtlcALrB6XVr5VAEtDt",
    "https://drive.google.com/uc?export=view&id=1OFdH5ArIq_hFCBCD-AYlYzsy6cISY5NM",
    "https://drive.google.com/uc?export=view&id=1PWZ4PSKcsXPgS_pjj3oKoQ3gVpY54r5Y",
    "https://drive.google.com/uc?export=view&id=1xLSsP8SFjjT2yTFqqRlaatSzLYa6opb_",
    "https://drive.google.com/uc?export=view&id=1_xx7RT0kYuIujI4BWHXrzZfEPYaOwuuH",
    "https://drive.google.com/uc?export=view&id=1dH573zBXw-PlOTj2BWZBIiBkBGupDngL",
    "https://drive.google.com/uc?export=view&id=1vT1QPPc1v4TR_N2Zm1VfIWFvL-zVYGGM",
    "https://drive.google.com/uc?export=view&id=1144_26h6X1w2GsZjwQ9SnhMoBDWTHD-F",
    "https://drive.google.com/uc?export=view&id=1yQq-XCrnQNff95HYVEL-5jcbLcv-mLel",
    "https://drive.google.com/uc?export=view&id=1AzAk7KnzrgFndo8Av1LZZt8nfR0MNlBt",
    "https://drive.google.com/uc?export=view&id=1fE7iyV5IB2V3ZhoJ6HNFeAZRsF2tO9ic",
    "https://drive.google.com/uc?export=view&id=1v8tmCDlTsKu9MniiztbY5eAKAXktetKC",
    "https://drive.google.com/uc?export=view&id=11QWqkG8WJQW_0sEzKoUPiD5SGrhkWpKv",
    "https://drive.google.com/uc?export=view&id=1AvZit2n1TcWsiXoRfSsKavRY0jeXP-uJ",
    "https://drive.google.com/uc?export=view&id=1RTGPZTl8c_MSzmOuFER_AcEPIqRgAsHk",
    "https://drive.google.com/uc?export=view&id=1hrbCCyjPocbYXf3lEXTFZdH7NFhf4_Cy",
    "https://drive.google.com/uc?export=view&id=1vVxHfj6rM0W44YB7Yxat2qIAh0EUG8MM",
    "https://drive.google.com/uc?export=view&id=1ga5n6xgKxk401G1LGRghvauyVhbpEm1R",
    "https://drive.google.com/uc?export=view&id=19THRKpBOqj6mZYhWI1VYoDm9SWprlJkr",
    "https://drive.google.com/uc?export=view&id=1L4wCP1bhfVKLxEP3RlhFcZsSpBhjue27",
    "https://drive.google.com/uc?export=view&id=1sXhG1fcg0gsp-jNOWzWCCRwEHLtSK_zz",
    "https://drive.google.com/uc?export=view&id=14tPY9C95MKPV_UXIc_tezpRMb5eGxKPL",
    "https://drive.google.com/uc?export=view&id=1C_Ziwo_ebbM5Qz1hbwkzH866tJwdL8zC",
    "https://drive.google.com/uc?export=view&id=1FfHgDLAO4e2ioTAMO_Xq9Xjkt-hRIVhy",
    "https://drive.google.com/uc?export=view&id=1MlSZsCsxKjZB_AiN_eOU5QPJC04TZn6G",
    "https://drive.google.com/uc?export=view&id=1ZrkSP1dL8bY4NNjLAdxdewHD58zqQdy0",
    "https://drive.google.com/uc?export=view&id=1aSAKoTNgdxlSvbyc2gN6lTV26hoWpjCb",
    "https://drive.google.com/uc?export=view&id=1cjkrJzHVj-RlONc_UDm63orat3gppOwB",
    "https://drive.google.com/uc?export=view&id=1hca4TwIq5_oSzbWY3zBGCzJR3eyRLUUL",
    "https://drive.google.com/uc?export=view&id=16jLv2FdCk3saGtvQyjw1Uw3OkyjcBKiH",
    "https://drive.google.com/uc?export=view&id=17nSlMc8sPDHZFyQH4SjA-COzGwPIbFuP",
    "https://drive.google.com/uc?export=view&id=1B6TK_y5QBOtRUBOt2PK4_GOF5iYI4mZF",
    "https://drive.google.com/uc?export=view&id=1BolcE6oOMhqLaWFN-f_1lafAIKv6sTDQ",
    "https://drive.google.com/uc?export=view&id=1E1Sno6g0YEhozSQmuSLZkbixcaUngk0S",
    "https://drive.google.com/uc?export=view&id=1HjZ0Pn4OT28QCXogiVAUEd5fP2TdRPoT",
    "https://drive.google.com/uc?export=view&id=1N75_OjLVR1qRSPLJOa_0BjpGX89AwpWp",
    "https://drive.google.com/uc?export=view&id=1OVQD4gcdoVw0quK9jXXt65l29G-REGI5",
    "https://drive.google.com/uc?export=view&id=1wVhWgB5eVhrut7oKDhdZyt2nm9Tb0bSA",
    "https://drive.google.com/uc?export=view&id=149OQpDDP0W4ibJJcM9yt8eDSzivESfIB",
    "https://drive.google.com/uc?export=view&id=14E7EyhIqWvDDTEtNZUqso0ardgJpeUf4",
    "https://drive.google.com/uc?export=view&id=1GNDgxR7FmFQbPz1HWiD63TzpvAuSe0UM",
    "https://drive.google.com/uc?export=view&id=1WQJW7lQ-At9WQXvszFu3u0-5MGCVBVSW",
    "https://drive.google.com/uc?export=view&id=1_o7amyePI3SepNvyUG0OeMyqgYHC19dQ",
    "https://drive.google.com/uc?export=view&id=1dp-zuUm9EoHaf6rpEeQIpx5BMQmIqc0M",
    "https://drive.google.com/uc?export=view&id=1njH4DrC4H6ByH1686ZciLnWOJRwv5xFf",
    "https://drive.google.com/uc?export=view&id=1yPG1P0K9_gu9o8GyDkQO6o8Tf1GgcJiW",
    "https://drive.google.com/uc?export=view&id=12lt6o6l8QWgDlZ16Fkb9dpl8nhpcxYYK",
    "https://drive.google.com/uc?export=view&id=1J2eNGcwBCFSLffA80pYDUi-ESOM3elWO",
    "https://drive.google.com/uc?export=view&id=1ZA9dLOO9Z9ZC1J2knK7ZCeyPt8NjbPel",
    "https://drive.google.com/uc?export=view&id=1jYxCNjfxgrFERyNKZSd3mNzV2tHROV6N",
    "https://drive.google.com/uc?export=view&id=1vvAaAsc6gw6DOvBv2KgggqcMmNnZmkP8",
    "https://drive.google.com/uc?export=view&id=14aHFkKDJiTwjl9xBzNu8wL3uuxBPfYsI",
    "https://drive.google.com/uc?export=view&id=17WPuIrACs8_ki2I0lPzVYstrNg6oQM54",
    "https://drive.google.com/uc?export=view&id=1FaM7bPQO56_wPnFJIHLFIKpG6PmWZZVX",
    "https://drive.google.com/uc?export=view&id=1JQDieYgZPAIwgm93o92VRmy-MkiCwRqY",
    "https://drive.google.com/uc?export=view&id=1VOZPh-F6eGhwawbxD0Vekb2Of9CSO0lx",
    "https://drive.google.com/uc?export=view&id=1azVmKiTZFFhwRr5hGfXFzUbtwa3U3ENa",
    "https://drive.google.com/uc?export=view&id=1rBAXD_Z_XZMicI0dTU1k-sbE6yJFVazy",
    "https://drive.google.com/uc?export=view&id=1xJIXbo7Oqa7puycYgJYiTvb7OLGvHm-K",
    "https://drive.google.com/uc?export=view&id=18qkEp9Exk-apIbedYcCpfNhS17Vu4obd",
    "https://drive.google.com/uc?export=view&id=1IF4dkD9m05gH7p1AlITO7KrizpRm45DX",
    "https://drive.google.com/uc?export=view&id=1Jo8bRt0AyPvZqU1fR-H3MpV-UcKFA6g8",
    "https://drive.google.com/uc?export=view&id=1TkCnc65rYJ5wr4qF0Z0Pc6UY50JN_B3A",
    "https://drive.google.com/uc?export=view&id=1U7G9_HSrkGF29tBTm7oLHN25sJ_7sZxa",
    "https://drive.google.com/uc?export=view&id=1_e1z0ZNoOT6R61T9P14eXUnfc3hH2Ouw",
    "https://drive.google.com/uc?export=view&id=1mIHx6eC3ie2pBFc91Nq5Vmglm4mueZ2C",
    "https://drive.google.com/uc?export=view&id=1sDonz0rbHZHtWOLsZkUKMjCsSkCA6rf-",
    "https://drive.google.com/uc?export=view&id=1t4ICcRqx2MfBDYMvg4MZlszAaS4qlIlI",
    "https://drive.google.com/uc?export=view&id=1u42qjVFreJab6e-t_UgYNdDKnEDPTUK3",
    "https://drive.google.com/uc?export=view&id=134eVhM1Qn29VKhaEMyUAuOeYMYviRJw0",
    "https://drive.google.com/uc?export=view&id=14273Mod2-n0FtDFHP8jwlojh2vCQurWv",
    "https://drive.google.com/uc?export=view&id=1DF2uIRN6s_Eu7P2PvlCHmQpImH6XTAMC",
    "https://drive.google.com/uc?export=view&id=1LaajBwurosvDYwRfALA3ELj0xTDbV20g",
    "https://drive.google.com/uc?export=view&id=1RZ_O2gNuG4z7gfsKofHh3x9PfWXpMRXO",
    "https://drive.google.com/uc?export=view&id=1iE-BSRTrgUPbiKcIU6ezObtIpSjiiprh",
    "https://drive.google.com/uc?export=view&id=1rtZWxqMCfV1hhymVovFzdqSGz5f246Mr",
    "https://drive.google.com/uc?export=view&id=18e3eFDm-e8DmP7AB-yTR6hbfGwPDxfZQ",
    "https://drive.google.com/uc?export=view&id=1L1H9Q1OudYtktrMhBJMCRyhMmgyBvBHS",
    "https://drive.google.com/uc?export=view&id=1VI-IezlMYpSkvV-d696CP1ozZ2qe8g1A",
    "https://drive.google.com/uc?export=view&id=1YzdAOfk204tJG9xG58Vt2UG3tgZmGO7G",
    "https://drive.google.com/uc?export=view&id=1ZZ4ixtD571yFsNnt2ABWSpg0RdqSwMcP",
    "https://drive.google.com/uc?export=view&id=1_OAQCSjmRdQo0ol2Iozf23q8ysdm-2xK",
    "https://drive.google.com/uc?export=view&id=1eFsPCsO0rYSxZPniykX12NJ13WZjxCLR",
    "https://drive.google.com/uc?export=view&id=1nyV0bSLVqzvXysVaNlCxHh9Iy9sxO-Sn",
    "https://drive.google.com/uc?export=view&id=1px55wFkRP4vm5w9vIfYt00ThKYNbXXJ3",
    "https://drive.google.com/uc?export=view&id=14Jj5JcuUXlZNcDtyA2Z03yQGsY855Awd",
    "https://drive.google.com/uc?export=view&id=1mrYVru6lBb90AU0xFjWwyvMuhx-SAyTP",
    "https://drive.google.com/uc?export=view&id=1I8WKDg4kLPlp4PewfeszJOMLU6tuNPap",
    "https://drive.google.com/uc?export=view&id=1RB6VwD0jhVtAXRwTJhhOOHsro0-w7Snk",
    "https://drive.google.com/uc?export=view&id=1RcfXUOC1WUW4zBEpnT9I20fwFJpKFy7p",
    "https://drive.google.com/uc?export=view&id=1coW6IqGHO6E1Q4JH0oJu8iuJcdJxTEUa",
    "https://drive.google.com/uc?export=view&id=1eXTZQ0mURbv3xscOhWizAhLGCHBXBOEj",
    "https://drive.google.com/uc?export=view&id=1gZTjWsMLVjO6Bs_vDx4L7mqgvAo3-Hw8",
    "https://drive.google.com/uc?export=view&id=1zFqBYwNAV8aKX64KemRc-Jxqx0ihIQSd",
    "https://drive.google.com/uc?export=view&id=12ueiwTKYD7-UBBxJbjhpVEXDNPCEBNd4",
    "https://drive.google.com/uc?export=view&id=15M6MW9KxCrrTsULSqPS58q2Yc0IWT0UE",
    "https://drive.google.com/uc?export=view&id=1EdHOyKlrXM8uwYKFF0-vhRVtSSciNvFn",
    "https://drive.google.com/uc?export=view&id=1IL6T_OsJ5lZRU-Gbx19QPADEVN0SPj2L",
    "https://drive.google.com/uc?export=view&id=1YBVoYBzNa-wsEANkrPMIn5Qi6bAi84KK",
    "https://drive.google.com/uc?export=view&id=1fUD3TZ8MTXEGPYteD4QoSUTXtbh1mnc4",
    "https://drive.google.com/uc?export=view&id=1frSlHw1883Y-GXjV0SHurCJiyRWDGqMC",
    "https://drive.google.com/uc?export=view&id=1Q6n2BXPRYFuyiZ-rH7_puoR-nAPdRc9D",
    "https://drive.google.com/uc?export=view&id=1RGNt2xt9KnBBAkUoYWLq3KNghTjP1OEC",
    "https://drive.google.com/uc?export=view&id=1RSBziVGqNaIw1ly5-z8fHF6T0_eAZlvv",
    "https://drive.google.com/uc?export=view&id=1Tkn000wHG42lv1elpCP_5y-x_Ox7lF-w",
    "https://drive.google.com/uc?export=view&id=1cL7iY1Ck9Kfu7WxCLlQ7q0cr1RVua1Sj",
    "https://drive.google.com/uc?export=view&id=1uOjJyneacSHiYT7JG1m2TyUK7LqO_Iok",
    "https://drive.google.com/uc?export=view&id=1x3lS6ZAjpncFaRHsaZKg-pzSGpnUwooA",
    "https://drive.google.com/uc?export=view&id=19DkA8lMm2NrJzNmKrqvCrT7qtXJQRUO2",
    "https://drive.google.com/uc?export=view&id=1EXgUG0bWE9H88rQxSVm7YuF4xofJ0oFY",
    "https://drive.google.com/uc?export=view&id=1I-DAuYonurfvtEJYmq2-7KPxWCtwvDnw",
    "https://drive.google.com/uc?export=view&id=1hubwT7sw7SK3trc_agXuF7BVfh-xDaoV",
    "https://drive.google.com/uc?export=view&id=1pW2MvphA0YdHxF7c3h1AejM8CRx0jsQF",
    "https://drive.google.com/uc?export=view&id=10bA788tKWWfShpWy7bDr52A7KV8mrUB1",
    "https://drive.google.com/uc?export=view&id=166T1E1WvqbXlyLeV6sw0nJM3kvgdhvil",
    "https://drive.google.com/uc?export=view&id=1mdbHAcGN4GnwMpo2Tggt59-gZDRYomGe",
    "https://drive.google.com/uc?export=view&id=1wL-RLU2O3jPXNi-v0D69o0z1QzsOlBG1",
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
