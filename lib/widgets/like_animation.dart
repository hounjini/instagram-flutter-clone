import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;
  const LikeAnimation(
      {Key? key,
      required this.child,
      required this.isAnimating,
      this.duration = const Duration(milliseconds: 150),
      this.onEnd,
      this.smallLike = false})
      : super(key: key);

  @override
  _LikeAnimationState createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  //scale은 initState()에서 1~1.2로 duration기간 / 2 동안 변하라고 해놨는데
  //이게 내부적으로 setState()가 호출되는 모양.

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
      //애니메이션 전체 기간의 반 만큼 커졌다가, 전체 기간의 반 만큼 작아져서
      //총 전체 기간만큼 애니메이션이 있을 거니까
      //2로 나눈 정수만 가져간다.
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
    //1로 시작해서 1.2가 된다.
    //그 interpolation.
  }

  //밖에서 setState로 isAnimating 변수값을 false -> true로 바꿨고
  //setState때문에 이 위젯이 새로 그려지는
  //새로 그려질 때 과거의 값과 현재 값 (과거 false -> 현재 true)가 되었기 때문에
  //이때만 animation을 실행시킨다.
  //새로그리더라도 animating값이 같으면 animation을 그리지 않는다.
  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimating || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(
        const Duration(
          milliseconds: 200,
        ),
      );
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
