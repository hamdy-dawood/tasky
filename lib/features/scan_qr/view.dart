import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/theming/assets.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/core/widgets/svg_icons.dart';
import 'package:tasky_app/features/details/view.dart';

class QrScanView extends StatefulWidget {
  const QrScanView({super.key});

  @override
  State<QrScanView> createState() => _QrScanViewState();
}

class _QrScanViewState extends State<QrScanView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgIcon(
            icon: AssetsStrings.arrowLeft,
            color: ColorManager.black,
            height: 25.h,
          ),
        ),
        title: CustomText(
          text: "Scan Qr",
          color: ColorManager.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: buildQrView(context),
    );
  }

  QRView buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          cutOutSize: 0.7.sw,
          borderRadius: 10.r,
          borderColor: ColorManager.mainColor,
          borderWidth: 10.w,
          borderLength: 20.w,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        result = barcode;
        result != null
            ? MagicRouter.navigateReplacement(
                page: DetailsView(
                fromScanner: true,
                id: "${result!.code}",
                user: "",
              ))
            : null;
      });
    });
  }
}
