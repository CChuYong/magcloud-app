import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../view/designsystem/base_color.dart';
import '../util/debouncer.dart';
import 'base_view.dart';

abstract class BaseViewModel<V extends BaseView<V, A, S>,
    A extends BaseViewModel<V, A, S>, S> extends GetxController {
  S state;

  BaseViewModel(this.state);

  bool isBusy = true; // must be started as true
  bool isLoading = false;

  String? imagePreviewUrl = null;

  final Debouncer reloadDbn = Debouncer(const Duration(milliseconds: 300));
  final Debouncer renderDbn = Debouncer(const Duration(milliseconds: 50));

  Future<void> initState();

  Future reloadScreen() async {
    await reloadDbn.runLastFuture(() => onReady());
  }

  @protected
  void render() {
    if (state != null) renderDbn.runLastCall(() => update());
  }

  void onReloaded() {}

  void setBottomColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: color,
    ));
  }

  void setLoading(bool loading) {
    isLoading = loading;
    render();
  }

  Future<bool> onWillPop() async {
    print("ONWILLPOP");
    return true;
  }

  @override
  Future<void> onReady() async {
    if (!isBusy) {
      isBusy = true;
      render();
    }

    await initState();
    isBusy = false;

    render();
  }

  Future<T> asyncLoading<T>(Future<T> Function() lambda) async {
    try {
      setLoading(true);
      return await lambda();
    } finally {
      setLoading(false);
    }
  }

  void dispose() {
    //super.dispose();
  }

  void didChangeDependencies(BuildContext context) {
    // there sould be nothing here, only helper for mixin
  }

  void setImagePreview(String url) {
    imagePreviewUrl = url;
    render();
  }

  void clearImagePreview() {
    imagePreviewUrl = null;
    render();
  }

  Future<void> setStateAsync(Future Function() lambda) async {
    await lambda();
    render();
  }

  void setState(VoidCallback fn) {
    fn();
    render();
  }

  Future doUpdate(Future func) async {
    try {
      setLoading(true);
      return await func;
    } finally {
      setLoading(false);
    }
  }

  void confirmModal({
    required String content,
    required String confirmText,
    String cancelText = '취소',
    required Function onConfirm,
  }) {
    defaultDialog(
      contentText: content,
      buttonText: confirmText,
      onPerform: () => onConfirm(),
    );
  }

  Future<T?> defaultDialog<T>({
    String? contentText,
    Widget? content,
    VoidCallback? onPerform,
    String? buttonText,
  }) {
    return showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 350),
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
      pageBuilder: (_, _1, _2) => AlertDialog(
        backgroundColor: BaseColor.defaultBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(24.0),
          ),
        ),
        content: Builder(
          builder: (context) {
            var width = MediaQuery.of(context).size.width;
            return Container(
              width: width - 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 5.sp),
                  content ??
                      Text(contentText ?? '내용을 입력해주세요',
                          style: TextStyle(
                            color: BaseColor.warmGray600,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          )),
                  SizedBox(height: 15.sp),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.fromHeight(5.sp),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      backgroundColor: BaseColor.green600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () {
                      onPerform?.call();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.sp),
                      child: Text(
                        buttonText ?? "이거슨 버튼입니당",
                        style: TextStyle(
                          color: BaseColor.green100,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is A && o.state == state;
  }

  @override
  int get hashCode => state.hashCode;
}
