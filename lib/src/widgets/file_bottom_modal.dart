import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../common/helpers.dart';

enum FileType { video, image }

class FileBottomModal extends StatelessWidget {
  final Function(XFile? file) onCameraTap;
  final Function(XFile? file) onFolderTap;
  final FileType type;

  const FileBottomModal({
    Key? key,
    required this.onCameraTap,
    required this.onFolderTap,
    this.type = FileType.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 26),
      decoration: const BoxDecoration(
        color: Color(0xFFFDFDFD),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: 3,
            decoration: const ShapeDecoration(
              shape: StadiumBorder(),
              color: Color(0xFFF4F5F4),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Choose ${type == FileType.image ? "Image" : "Video"} To Upload',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          // SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 18),

          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom + 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    color: const Color.fromRGBO(252, 175, 69, 1),
                    child: Material(
                      borderRadius: BorderRadius.circular(100),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          XFile? file;
                          if (type == FileType.image) {
                            file = await Helpers.takeImage();
                          } else if (type == FileType.video) {
                            file = await Helpers.takeVideo();
                          }
                          onCameraTap(file);
                        },
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    color: const Color(0xFF429BED),
                    child: Material(
                      borderRadius: BorderRadius.circular(100),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          XFile? file;
                          if (type == FileType.image) {
                            file = await Helpers.selectImage();
                          } else if (type == FileType.video) {
                            file = await Helpers.selectVideo();
                          }
                          onFolderTap(file);
                        },
                        child: const Icon(
                          Icons.folder_special,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
