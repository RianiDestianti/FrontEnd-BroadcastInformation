import 'package:flutter/material.dart';

class DarkModeToggle extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggle;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final Duration animationDuration;

  const DarkModeToggle({
    Key? key,
    required this.isDarkMode,
    required this.onToggle,
    this.size = 24.0,
    this.activeColor,
    this.inactiveColor,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<DarkModeToggle> createState() => _DarkModeToggleState();
}

class _DarkModeToggleState extends State<DarkModeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (widget.isDarkMode) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(DarkModeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDarkMode != oldWidget.isDarkMode) {
      if (widget.isDarkMode) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onToggle(!widget.isDarkMode),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: widget.size * 2,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.size / 2),
              color: Color.lerp(
                widget.inactiveColor ?? Colors.grey[300]!,
                widget.activeColor ?? Colors.blue[600]!,
                _animation.value,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background icons
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Opacity(
                        opacity: 1 - _animation.value,
                        child: Icon(
                          Icons.wb_sunny,
                          size: widget.size * 0.6,
                          color: Colors.orange[600],
                        ),
                      ),
                      Opacity(
                        opacity: _animation.value,
                        child: Icon(
                          Icons.nights_stay,
                          size: widget.size * 0.6,
                          color: Colors.yellow[100],
                        ),
                      ),
                    ],
                  ),
                ),
                // Toggle circle
                AnimatedPositioned(
                  duration: widget.animationDuration,
                  curve: Curves.easeInOut,
                  left: widget.isDarkMode ? widget.size : 2,
                  top: 2,
                  child: Container(
                    width: widget.size - 4,
                    height: widget.size - 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      size: widget.size * 0.5,
                      color: widget.isDarkMode ? Colors.grey[700] : Colors.orange[600],
                    ),
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

// Alternative simple toggle button
class SimpleDarkModeToggle extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggle;
  final double size;
  final Color? iconColor;

  const SimpleDarkModeToggle({
    Key? key,
    required this.isDarkMode,
    required this.onToggle,
    this.size = 24.0,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationTransition(
            turns: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: Icon(
          isDarkMode ? Icons.light_mode : Icons.dark_mode,
          key: ValueKey(isDarkMode),
          size: size,
          color: iconColor ?? (isDarkMode ? Colors.orange : Colors.grey[700]),
        ),
      ),
      onPressed: () => onToggle(!isDarkMode),
    );
  }
}

// Custom switch-style toggle
class SwitchStyleToggle extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggle;
  final String? lightLabel;
  final String? darkLabel;

  const SwitchStyleToggle({
    Key? key,
    required this.isDarkMode,
    required this.onToggle,
    this.lightLabel = 'Light',
    this.darkLabel = 'Dark',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (lightLabel != null) ...[
          Text(
            lightLabel!,
            style: TextStyle(
              fontSize: 14,
              color: !isDarkMode ? Colors.blue[600] : Colors.grey[600],
              fontWeight: !isDarkMode ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Switch(
          value: isDarkMode,
          onChanged: onToggle,
          activeColor: Colors.blue[600],
          inactiveThumbColor: Colors.orange[600],
          inactiveTrackColor: Colors.orange[100],
        ),
        if (darkLabel != null) ...[
          const SizedBox(width: 8),
          Text(
            darkLabel!,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.blue[600] : Colors.grey[600],
              fontWeight: isDarkMode ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ],
    );
  }
}