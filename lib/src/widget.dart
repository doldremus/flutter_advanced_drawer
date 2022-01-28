part of '../flutter_advanced_drawer.dart';

/// AdvancedDrawer widget.
class AdvancedDrawer extends StatefulWidget {
  const AdvancedDrawer({
    Key? key,
    required this.child,
    required this.drawer,
    this.controller,
    this.backdropColor,
    this.drawerSlideRatio = 0.85,
    this.childSlideRatio = 0.75,
    this.childScaleRatio = 0.85,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve,
    this.childAnimationDecoration,
    this.animateChildDecoration = true,
    this.rtlOpening = false,
    this.gesturesDisabled = false,
    this.gesturesClingWidth = 30,
    this.animationController,
  }) : super(key: key);

  /// Child widget. (Usually widget that represent a screen)
  final Widget child;

  /// Drawer widget. (Widget behind the [child]).
  final Widget drawer;

  /// Controller that controls widget state.
  final AdvancedDrawerController? controller;

  /// Backdrop color.
  final Color? backdropColor;

  /// Drawer slide ratio, in most cases [drawerSlideRatio] = [childSlideRatio]
  final double drawerSlideRatio;

  /// Child slide ratio.
  final double childSlideRatio;

  /// Child scale ratio.
  final double childScaleRatio;

  /// Animation duration.
  final Duration animationDuration;

  /// Animation curve.
  final Curve? animationCurve;

  /// Child container decoration in open widget state.
  final BoxDecoration? childAnimationDecoration;

  /// Indicates that [childAnimationDecoration] might be animated or not.
  /// NOTICE: It may cause animation jerks.
  final bool animateChildDecoration;

  /// Opening from Right-to-left.
  final bool rtlOpening;

  /// Disable gestures.
  final bool gesturesDisabled;

  /// Gestures left side width when drawer closed.
  final double gesturesClingWidth;

  /// Controller that controls widget animation.
  final AnimationController? animationController;

  @override
  _AdvancedDrawerState createState() => _AdvancedDrawerState();
}

class _AdvancedDrawerState extends State<AdvancedDrawer> with SingleTickerProviderStateMixin {
  late final AdvancedDrawerController _controller;
  late final AnimationController _animationController;
  late final Animation<double> _drawerScaleAnimation;
  late final Animation<Offset> _childSlideAnimation;
  late final Animation<double> _childScaleAnimation;
  late final Animation<Decoration> _childDecorationAnimation;
  late double _offsetValue;
  late Offset _freshPosition;
  Offset? _startPosition;
  bool _captured = false;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? AdvancedDrawerController();
    _controller.addListener(handleControllerChanged);

    _animationController = widget.animationController ??
        AnimationController(
          vsync: this,
          value: _controller.value.visible ? 1 : 0,
        );

    _animationController.duration = widget.animationDuration;

    final parentAnimation = widget.animationCurve != null
        ? CurvedAnimation(
            curve: widget.animationCurve!,
            parent: _animationController,
          )
        : _animationController;

    _drawerScaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(parentAnimation);

    _childSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(widget.childSlideRatio, 0),
    ).animate(parentAnimation);

    _childScaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.childScaleRatio,
    ).animate(parentAnimation);

    _childDecorationAnimation = DecorationTween(
      begin: const BoxDecoration(),
      end: widget.childAnimationDecoration,
    ).animate(parentAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backdropColor,
      child: Stack(
        children: <Widget>[
          /// -------- DRAWER ---------
          Align(
            alignment: widget.rtlOpening ? Alignment.centerRight : Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: widget.drawerSlideRatio,
              child: ScaleTransition(
                scale: _drawerScaleAnimation,
                alignment: widget.rtlOpening ? Alignment.centerLeft : Alignment.centerRight,
                child: widget.drawer,
              ),
            ),
          ),

          /// -------- CHILD ----------
          SlideTransition(
            position: _childSlideAnimation,
            textDirection: widget.rtlOpening ? TextDirection.rtl : TextDirection.ltr,
            child: ScaleTransition(
              scale: _childScaleAnimation,
              child: Builder(
                builder: (_) {
                  final childStack = Stack(
                    children: [
                      widget.child,

                      /// ---OVERLAY---
                      ValueListenableBuilder<AdvancedDrawerValue>(
                        valueListenable: _controller,
                        builder: (_, value, __) {
                          if (!value.visible) {
                            return const SizedBox();
                          }

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _controller.hideDrawer,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              child: Container(),
                            ),
                          );
                        },
                      ),
                    ],
                  );

                  if (widget.animateChildDecoration && widget.childAnimationDecoration != null) {
                    return AnimatedBuilder(
                      animation: _childDecorationAnimation,
                      builder: (_, child) {
                        return Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: _childDecorationAnimation.value,
                          child: child,
                        );
                      },
                      child: childStack,
                    );
                  }

                  return childStack;
                },
              ),
            ),
          ),

          /// -------- GESTURES --------
          ValueListenableBuilder<AdvancedDrawerValue>(
            valueListenable: _controller,
            builder: (_, value, __) => SizedBox(
              width: value.visible ? double.infinity : widget.gesturesClingWidth,
              child: GestureDetector(
                onHorizontalDragStart: widget.gesturesDisabled ? null : _handleDragStart,
                onHorizontalDragUpdate: widget.gesturesDisabled ? null : _handleDragUpdate,
                onHorizontalDragEnd: widget.gesturesDisabled ? null : _handleDragEnd,
                onHorizontalDragCancel: widget.gesturesDisabled ? null : _handleDragCancel,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleControllerChanged() {
    _controller.value.visible ? _animationController.forward() : _animationController.reverse();
  }

  void _handleDragStart(DragStartDetails details) {
    _captured = true;
    _startPosition = details.globalPosition;
    _offsetValue = _animationController.value;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_captured) return;

    final screenSize = MediaQuery.of(context).size;

    _freshPosition = details.globalPosition;

    final diff = (_freshPosition - _startPosition!).dx;

    _animationController.value =
        _offsetValue + (diff / (screenSize.width * widget.childSlideRatio)) * (widget.rtlOpening ? -1 : 1);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_captured) return;

    _captured = false;

    if (_animationController.value >= 0.5) {
      if (_controller.value.visible) {
        _animationController.forward();
      } else {
        _controller.showDrawer();
      }
    } else {
      if (!_controller.value.visible) {
        _animationController.reverse();
      } else {
        _controller.hideDrawer();
      }
    }
  }

  void _handleDragCancel() {
    _captured = false;
  }

  @override
  void dispose() {
    _controller.removeListener(handleControllerChanged);

    if (widget.controller == null) {
      _controller.dispose();
    }

    if (widget.animationController == null) {
      _animationController.dispose();
    }

    super.dispose();
  }
}
