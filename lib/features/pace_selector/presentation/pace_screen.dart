import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pace_provider.dart';
import '../../user_list/presentation/user_list_screen.dart';

/// The final production-ready pixel-perfect implementation of the Pace Selector screen.
/// 
/// Orchestrates premium dark radial background glow fields, un-weighted fine typography, 
/// custom text fields, and highly responsive segmented track timeline boundaries.
class PaceScreen extends StatefulWidget {
  const PaceScreen({super.key});

  @override
  State<PaceScreen> createState() => _PaceScreenState();
}

class _PaceScreenState extends State<PaceScreen> {
  // Input window state controllers for explicit textual property sync loops
  late TextEditingController _minController;
  late TextEditingController _secController;

  @override
  void initState() {
    super.initState();
    // Fetch a non-reactive baseline snapshot to seed controller text fields initially
    final provider = Provider.of<PaceProvider>(context, listen: false);
    _minController = TextEditingController(text: provider.minutes.toString());
    _secController = TextEditingController(text: provider.seconds.toString().padLeft(2, '0'));
  }

  @override
  void dispose() {
    // Prevent memory retention by explicitly cleaning up native input elements
    _minController.dispose();
    _secController.dispose();
    super.dispose();
  }

  // Intercepts and aligns direct keyboard updates to prevent recursive widget rebuild loops
  void _updateControllers(int mins, int secs) {
    if (_minController.text != mins.toString()) {
      _minController.text = mins.toString();
    }
    final formattedSecs = secs.toString().padLeft(2, '0');
    if (_secController.text != formattedSecs) {
      _secController.text = formattedSecs;
    }
  }

  // Returns the precise dynamic branding hex color mapping for each competitive swimmer tier
  Color _getThemeColor(String level) {
    switch (level) {
      case 'Elite':
        return const Color(0xFFFFA500); // Dynamic Orange/Gold Accent
      case 'Advanced':
        return const Color(0xFF2E93E4); // Corporate Profile Blue Accent
      case 'Intermediate':
        return const Color(0xFF33C29D); // Neon Mint/Teal Active Accent
      case 'Beginner':
      default:
        return const Color(0xFF90A4AE); // Muted Industrial Steel Grey Accent
    }
  }

  @override
  Widget build(BuildContext context) {
    // Actively watch reactive changes in PaceProvider to trigger structural tree paint routines
    final provider = context.watch<PaceProvider>();
    _updateControllers(provider.minutes, provider.seconds);
    final activeColor = _getThemeColor(provider.swimmerLevel);

    return Scaffold(
      body: Container(
        // Generates the deep dark blue ambient background radial glow mask
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.5), // Glow point focused directly behind headers
            radius: 1.2,
            colors: [
              Color(0xFF0F1E2D), // Soft metallic blue-grey upper atmosphere field
              Color(0xFF050A0F), // Solid obsidian bottom foundation panel
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Minimal circular asset vector backing container routing action handle
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF142230),
                    ),
                    child: const Icon(
                      Icons.chevron_left, color: Colors.white60, size: 24
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Multi-tier progress segmented line header row view layout
                Row(
                  children: List.generate(
                    5,
                    (index) => Expanded(
                      child: Container(
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: index == 0 ? activeColor : Colors.white10,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Main screen branding typography layout headers
                const Text(
                  "What's your fastest\n100m freestyle?",
                  style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w700, 
                    color: Colors.white, height: 1.2, 
                    letterSpacing: -0.5, fontFamily: 'Roboto'
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "This helps us build a more accurate plan for you.",
                  style: TextStyle(
                    fontSize: 14, color: Colors.white38, height: 1.3, 
                    fontFamily: 'Roboto'
                  ),
                ),
                
                const Spacer(),
                
                const Center(
                  child: Text(
                    "YOUR PACE",
                    style: TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold, 
                      color: Colors.white24, letterSpacing: 2.0, 
                      fontFamily: 'Roboto'
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Symmetric coordinate time input layout columns panel
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildCustomTimeColumn(
                      context: context,
                      controller: _minController,
                      onChanged: (val) => provider.updateMinutes(int.tryParse(val) ?? 0),
                      onIncrement: () => provider.updateMinutes(provider.minutes + 1),
                      onDecrement: () => provider.updateMinutes(provider.minutes - 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, left: 0.0, right: 19.0),
                      // High-contrast clean monospace square colon layout separator widget
                      child: Text(
                        ':', style: GoogleFonts.robotoMono(
                          fontSize: 72, fontWeight: FontWeight.normal, 
                          color: const Color(0xFF33C29D)
                        )),
                    ),
                    _buildCustomTimeColumn(
                      context: context,
                      controller: _secController,
                      onChanged: (val) => provider.updateSeconds(int.tryParse(val) ?? 0),
                      onIncrement: () => provider.updateSeconds(provider.seconds + 1),
                      onDecrement: () => provider.updateSeconds(provider.seconds - 1),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                const Center(
                  child: Text(
                    "MIN : SEC / 100M",
                    style: TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold, 
                      color: Colors.white24, letterSpacing: 1.5, 
                      fontFamily: 'Roboto'
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Dynamic metric classification section displaying current swimmer brackets
                Center(
                  child: Column(
                    children: [
                      const Text(
                        "THAT PUTS YOU AT",
                        style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold, 
                          color: Color.fromARGB(108, 255, 255, 255), 
                          letterSpacing: 1.2, fontFamily: 'Roboto'
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        provider.swimmerLevel,
                        style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700, 
                          color: activeColor, letterSpacing: 0.5, 
                          fontFamily: 'Roboto'
                        ), 
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),

                // 1. Swimmer level text labels dynamically highlighting the active zone in bright white
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Row(
                    children: [
                      Expanded(child: Center(
                        child: Text('Elite', style: TextStyle(
                          fontSize: 11, color: provider.swimmerLevel == 'Elite' ? 
                          Colors.white : Colors.white24, 
                          fontWeight: provider.swimmerLevel == 'Elite' ? 
                          FontWeight.w700 : FontWeight.w500, fontFamily: 'Roboto')
                        ))),
                      Expanded(child: Center(
                        child: Text('Advanced', style: TextStyle(
                          fontSize: 11, color: provider.swimmerLevel == 'Advanced' ? 
                          Colors.white : Colors.white24, 
                          fontWeight: provider.swimmerLevel == 'Advanced' ? 
                          FontWeight.w700 : FontWeight.w500, fontFamily: 'Roboto')
                        ))),
                      Expanded(child: Center(
                        child: Text('Intermediate', style: TextStyle(
                          fontSize: 11, color: provider.swimmerLevel == 'Intermediate' ? 
                          Colors.white : Colors.white24, 
                          fontWeight: provider.swimmerLevel == 'Intermediate' ? 
                          FontWeight.w700 : FontWeight.w500, fontFamily: 'Roboto')
                        ))),
                      Expanded(child: Center(
                        child: Text('Beginner', style: TextStyle(
                          fontSize: 11, color: provider.swimmerLevel == 'Beginner' ? 
                          Colors.white : Colors.white24, 
                          fontWeight: provider.swimmerLevel == 'Beginner' ? 
                          FontWeight.w700 : FontWeight.w500, fontFamily: 'Roboto')
                        ))),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              
              // 2. Resilient Segmented Track Slider bound strictly to fractional step nodes
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2.0,
                  // Custom Track Shape dynamically tracking the 4 discrete step intervals
                  trackShape: _CustomSegmentedTrackShape(
                    currentSliderValue: provider.currentSliderValue,
                    activeColor: activeColor,
                  ),
                  thumbColor: Colors.white,
                  overlayColor: activeColor.withOpacity(0.12),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                ),
                child: Slider(
                  value: provider.currentSliderValue.clamp(provider.minSliderValue, provider.maxSliderValue),
                  min: provider.minSliderValue,
                  max: provider.maxSliderValue,
                  onChanged: (value) => provider.updateFromSlider(value),
                ),
              ),
              const SizedBox(height: 6),

              // 3. Symmetrically balanced timestamp dividers aligned under the track line
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.0),
                child: Row(
                  children: [
                    Spacer(flex: 1),
                    Text('1:10', style: TextStyle(
                      fontSize: 11, color: Colors.white24, 
                      fontWeight: FontWeight.w500, fontFamily: 'Roboto')
                    ),
                    Spacer(flex: 1),
                    Text('1:30', style: TextStyle(
                      fontSize: 11, color: Colors.white24, 
                      fontWeight: FontWeight.w500, fontFamily: 'Roboto')
                    ),
                    Spacer(flex: 1),
                    Text('2:00', style: TextStyle(
                      fontSize: 11, color: Colors.white24, 
                      fontWeight: FontWeight.w500, fontFamily: 'Roboto')
                    ),
                    Spacer(flex: 1),
                  ],
                ),
              ),
              
              const Spacer(),

              // Error reporting container logging background sync exceptions
              if (provider.errorMessage != null && !provider.errorMessage!.contains('Success')) ...[
                Center(
                  child: Text(
                    provider.errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent, fontSize: 13, 
                      fontWeight: FontWeight.w500, fontFamily: 'Roboto'
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Adaptive execution routing button tracking active level changes
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeColor, 
                    foregroundColor: const Color(0xFF060B11),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                  ),
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          // Dispatch the asynchronous network sync request
                          await provider.sendPace();
                          if (context.mounted) {
                            final latestProvider = Provider.of<PaceProvider>(context, listen: false);
                            if (latestProvider.errorMessage != null && latestProvider.errorMessage!.contains('Success')) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const UserListScreen()),
                              );
                            }
                          }
                        },
                  child: provider.isLoading
                      ? const CircularProgressIndicator(color: Color(0xFF060B11))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Continue', style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, 
                              letterSpacing: 0.5, fontFamily: 'Roboto')
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Underlined fully interactive text skip action button forwarding workflows instantly
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserListScreen()),
                    );
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                  child: const Text(
                    "I don't know my pace, skip this",
                    style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500, 
                      color: Color.fromARGB(154, 255, 255, 255), decoration: TextDecoration.underline, 
                      fontFamily: 'Roboto'
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    ));
  }

  // Helper widget grouping numeric entry inputs inside structured container boxes
  Widget _buildCustomTimeColumn({
    required BuildContext context,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Upper hollow fine wire chevron text token arrow control
        GestureDetector(
          onTap: onIncrement,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 9.0),
            child: Text(
              '︿', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w100, color: Colors.white
              )
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF101B26), 
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: GoogleFonts.robotoMono(
              fontSize: 72,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              letterSpacing: 0.0,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none, isDense: true, 
              contentPadding: EdgeInsets.zero,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 4),
        // Lower hollow fine wire chevron text token arrow control
        GestureDetector(
          onTap: onDecrement,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 9.0),
            child: Text(
              '﹀', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w100, color: Colors.white
              )
            ), 
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "TAP TO EDIT",
          style: TextStyle(
            fontSize: 8, fontWeight: FontWeight.bold, 
            color: Color.fromARGB(53, 255, 255, 255), letterSpacing: 0.5, 
            fontFamily: 'Roboto'
          ),
        ),
      ],
    );
  }
}

/// Custom implementation of SliderTrackShape to render precise segment highlights based on swimmer tiers.
class _CustomSegmentedTrackShape extends SliderTrackShape {
  final double currentSliderValue;
  final Color activeColor; 
  
  _CustomSegmentedTrackShape({
    required this.currentSliderValue,
    required this.activeColor,
  });

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 3.0;
    final double trackLeft = offset.dx + 22.0; 
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 44.0;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
    );
    final Paint inactivePaint = Paint()..color = Colors.white12;
    final Paint activeSegmentPaint = Paint()..color = activeColor;

    // Paint the base underlying layout background wire channel
    context.canvas.drawRect(trackRect, inactivePaint);

    // Resolves precise horizontal coordinate pixels for each distinct timeline segment split node
    double getDxForSegmentNode(double segmentIndex) {
      double pct = segmentIndex / 4.0;
      return trackRect.left + (trackRect.width * pct);
    }

    double segmentLeft = trackRect.left;
    double segmentRight = trackRect.right;

    // Evaluate current fractions system (0.0 to 4.0) to isolate targeted boundary blocks
    if (currentSliderValue <= 1.0) {
      segmentLeft = getDxForSegmentNode(0.0);
      segmentRight = getDxForSegmentNode(1.0);
    } else if (currentSliderValue <= 2.0) {
      segmentLeft = getDxForSegmentNode(1.0);
      segmentRight = getDxForSegmentNode(2.0);
    } else if (currentSliderValue <= 3.0) {
      segmentLeft = getDxForSegmentNode(2.0);
      segmentRight = getDxForSegmentNode(3.0);
    } else {
      segmentLeft = getDxForSegmentNode(3.0);
      segmentRight = getDxForSegmentNode(4.0);
    }

    // Wrap the bounding positions within a clean rectangle object geometry slice
    final Rect activeSegmentRect = Rect.fromLTRB(
      segmentLeft,
      trackRect.top,
      segmentRight,
      trackRect.bottom,
    );

    // Overlay active tier colors on top of canvas track matrices
    context.canvas.drawRect(activeSegmentRect, activeSegmentPaint);
  }
}

