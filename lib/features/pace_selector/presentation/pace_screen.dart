import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'pace_provider.dart';
import '../../user_list/presentation/user_list_screen.dart';

class PaceScreen extends StatefulWidget {
  const PaceScreen({super.key});

  @override
  State<PaceScreen> createState() => _PaceScreenState();
}

class _PaceScreenState extends State<PaceScreen> {
  late TextEditingController _minController;
  late TextEditingController _secController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PaceProvider>(context, listen: false);
    _minController = TextEditingController(text: provider.minutes.toString());
    _secController = TextEditingController(text: provider.seconds.toString().padLeft(2, '0'));
  }

  @override
  void dispose() {
    _minController.dispose();
    _secController.dispose();
    super.dispose();
  }

  // Synchronize TextFields when provider state changes from slider
  void _updateControllers(int mins, int secs) {
    if (_minController.text != mins.toString()) {
      _minController.text = mins.toString();
    }
    final formattedSecs = secs.toString().padLeft(2, '0');
    if (_secController.text != formattedSecs) {
      _secController.text = formattedSecs;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaceProvider>();
    _updateControllers(provider.minutes, provider.seconds);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pace Selector'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Swimmer Level Display
              Text(
                'Swimmer Level:',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                provider.swimmerLevel,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 48),

              // Timer Input Section (MIN : SEC)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeColumn(
                    context: context,
                    controller: _minController,
                    onChanged: (val) => provider.updateMinutes(int.tryParse(val) ?? 0),
                    onIncrement: () => provider.updateMinutes(provider.minutes + 1),
                    onDecrement: () => provider.updateMinutes(provider.minutes - 1),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(':', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                  ),
                  _buildTimeColumn(
                    context: context,
                    controller: _secController,
                    onChanged: (val) => provider.updateSeconds(int.tryParse(val) ?? 0),
                    onIncrement: () => provider.updateSeconds(provider.seconds + 1),
                    onDecrement: () => provider.updateSeconds(provider.seconds - 1),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Interactive Slider
              Slider(
                value: provider.totalSeconds.toDouble().clamp(provider.minSliderValue, provider.maxSliderValue),
                min: provider.minSliderValue,
                max: provider.maxSliderValue,
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.grey[800],
                onChanged: (value) => provider.updateFromSlider(value),
              ),

              // Slider Key Value Labels
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0:30', style: TextStyle(color: Colors.grey)),
                    Text('1:30', style: TextStyle(color: Colors.grey)),
                    Text('3:00', style: TextStyle(color: Colors.grey)),
                    Text('5:00', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Spacer(),

              // API Status Message
              if (provider.errorMessage != null) ...[
                Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: provider.errorMessage!.contains('Success') ? Colors.green : Colors.redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Continue Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          // 1. Trigger the API POST request
                          await provider.sendPace();
                          
                          // 2. Read the latest provider state after request completes
                          if (context.mounted) {
                            final latestProvider = Provider.of<PaceProvider>(context, listen: false);
                            
                            // 3. If there is no error or it's a Success message, navigate forward
                            if (latestProvider.errorMessage != null && 
                                latestProvider.errorMessage!.contains('Success')) {
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const UserListScreen()),
                              );
                            }
                          }
                        },
                  child: provider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget to build minutes and seconds controls
  Widget _buildTimeColumn({
    required BuildContext context,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up, size: 36, color: Colors.blueAccent),
          onPressed: onIncrement,
        ),
        SizedBox(
          width: 80,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(border: InputBorder.none),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            onChanged: onChanged,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 36, color: Colors.blueAccent),
          onPressed: onDecrement,
        ),
      ],
    );
  }
}
