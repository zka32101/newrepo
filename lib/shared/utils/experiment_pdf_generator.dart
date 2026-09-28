import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// じっけん・おうちラボの内容を印刷用PDFに変換する共通ユーティリティ。
///
/// 「用意するもの」は箇条書き、「手順」は番号付きで出力する。
/// [tips]・[safetyNote] は任意(ない場合はその見出し自体を省略)。
class PrintableExperiment {
  final String title;
  final int grade;
  final List<String> materials;
  final List<String> steps;
  final String? tips;
  final String? safetyNote;

  const PrintableExperiment({
    required this.title,
    required this.grade,
    required this.materials,
    required this.steps,
    this.tips,
    this.safetyNote,
  });
}

/// [experiment] からA4のPDFを生成し、OSの印刷/共有ダイアログを開く。
Future<void> printExperiment(PrintableExperiment experiment) async {
  final regularFont = await PdfGoogleFonts.notoSansJPRegular();
  final boldFont = await PdfGoogleFonts.notoSansJPBold();
  final theme = pw.ThemeData.withFont(base: regularFont, bold: boldFont);
  final doc = pw.Document(theme: theme);

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              experiment.title,
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text('${experiment.grade}年生むけ', style: const pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 16),
            _sectionTitle('用意するもの'),
            ...experiment.materials.map(
              (m) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4, left: 4),
                child: pw.Text('・$m', style: const pw.TextStyle(fontSize: 13)),
              ),
            ),
            pw.SizedBox(height: 16),
            _sectionTitle('手順'),
            ...experiment.steps.asMap().entries.map(
              (e) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6, left: 4),
                child: pw.Text(
                  '${e.key + 1}. ${e.value}',
                  style: const pw.TextStyle(fontSize: 13),
                ),
              ),
            ),
            if (experiment.tips != null) ...[
              pw.SizedBox(height: 16),
              _sectionTitle('学びのポイント'),
              pw.Text(experiment.tips!, style: const pw.TextStyle(fontSize: 13)),
            ],
            if (experiment.safetyNote != null) ...[
              pw.SizedBox(height: 16),
              _sectionTitle('安全上の注意'),
              pw.Text(experiment.safetyNote!, style: const pw.TextStyle(fontSize: 13)),
            ],
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (_) => doc.save(),
    name: '${experiment.title}.pdf',
  );
}

pw.Widget _sectionTitle(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 8),
    child: pw.Text(text, style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
  );
}
