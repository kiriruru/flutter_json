import 'dart:math';
import 'package:docxtpl/docxtpl.dart';

void generate() async {
  print("start generate");
  final DocxTpl docxTpl = DocxTpl(
    docxTemplate: "assets/tpl.docx",
    isAssetFile: true,
  );

  var templateData = {
    'CLIENT_FIO_UC': 'Begov Alimardon',
    'CLIENT_PASSPORT': '9988 777666',
    'COMPANY_NAME': 'Vanguard',
    'COMPANY_PIB': '00010010110',
    'DD_MM_YYYY': '02.03.2023',
  };

  var response = await docxTpl.parseDocxTpl();

  if (response.mergeStatus == MergeResponseStatus.Success) {
    await docxTpl.writeMergeFields(data: templateData);
    var savedFile = await docxTpl.save('generatedDocument.docx');
  }
}
