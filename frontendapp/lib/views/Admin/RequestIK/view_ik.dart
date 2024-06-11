import 'package:flutter/material.dart';
import 'package:frontendapp/controllers/request_ik_controller.dart';
import 'package:frontendapp/controllers/admin_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class IKView extends StatelessWidget {
  final int requestId;

  const IKView({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final AdminController adminController = Get.put(AdminController());

    return GetBuilder<RequestIKController>(
      builder: (controller) {
        var requestIKView = controller.requestIK
            .firstWhere((requestIk) => requestIk.id == requestId);

        return Center(
          child: Container(
            width: 350.0,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100], // Light grey background
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Detail Izin Keluar',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20.0),
                buildDetailRow(
                  title: 'Nama Mahasiswa',
                  content: FutureBuilder<String>(
                    future: adminController
                        .getNamaMahasiswaFromId(requestIKView.mahasiswaId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: Colors.blueGrey,
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.red,
                          ),
                        );
                      } else {
                        return Text(
                          snapshot.data ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black87,
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 12.0),
                buildDetailText(
                  title: 'Keterangan',
                  content: requestIKView.deskripsi,
                ),
                const SizedBox(height: 12.0),
                buildDetailText(
                  title: 'Tanggal Berangkat',
                  content: DateFormat('yyyy-MM-dd HH:mm WIB')
                      .format(requestIKView.tanggalBerangkat),
                ),
                const SizedBox(height: 12.0),
                buildDetailText(
                  title: 'Tanggal Kembali',
                  content: DateFormat('yyyy-MM-dd HH:mm WIB')
                      .format(requestIKView.tanggalKembali),
                ),
                const SizedBox(height: 12.0),
                buildDetailText(
                  title: 'Status',
                  content: requestIKView.status,
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (requestIKView.status == 'pending')
                      buildActionButton(
                        onPressed: () {
                          adminController.approveIK(id: requestIKView.id);
                        },
                        label: 'Approve',
                        color: Colors.green,
                      ),
                    if (requestIKView.status == 'pending')
                      buildActionButton(
                        onPressed: () {
                          adminController.rejectIK(id: requestIKView.id);
                        },
                        label: 'Reject',
                        color: Colors.red,
                      ),
                    buildActionButton(
                      onPressed: () {
                        Get.back();
                      },
                      label: 'Close',
                      color: Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDetailRow({required String title, required Widget content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(fontSize: 15.0, color: Colors.teal[900]),
        ),
        const SizedBox(width: 8.0),
        Expanded(child: content),
      ],
    );
  }

  Widget buildDetailText({required String title, required String content}) {
    return Text(
      '$title: $content',
      style: TextStyle(fontSize: 15.0, color: Colors.teal[900]),
    );
  }

  Widget buildActionButton({
    required VoidCallback onPressed,
    required String label,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        minimumSize: const Size(100, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
