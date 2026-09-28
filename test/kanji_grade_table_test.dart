import 'package:flutter_test/flutter_test.dart';
import 'package:shokollen_science/data/seeds/kanji_grade_table.dart';

void main() {
  test('1年生の漢字はちょうど80字', () {
    expect(grade1Kanji.length, 80);
  });

  test('2年生の漢字はちょうど160字', () {
    expect(grade2Kanji.length, 160);
  });

  test('1年生と2年生の漢字に重複はない', () {
    expect(grade1Kanji.intersection(grade2Kanji), isEmpty);
  });

  test('合計240字', () {
    expect(grade1And2Kanji.length, 240);
  });

  group('isAllGrade1Or2Kanji', () {
    test('1年生の漢字のみの熟語はtrue', () {
      expect(isAllGrade1Or2Kanji('水'), isTrue);
      expect(isAllGrade1Or2Kanji('力点'), isTrue); // 力(1年)+点(2年)
    });

    test('3年生以上の漢字を含む場合はfalse', () {
      expect(isAllGrade1Or2Kanji('磁石'), isFalse); // 磁も石も学年配当外/3年以上
      expect(isAllGrade1Or2Kanji('電磁石'), isFalse);
    });

    test('漢字を含まない文字列はfalse(ふりがな不要の判定に使わない)', () {
      expect(isAllGrade1Or2Kanji('ひらがな'), isFalse);
      expect(isAllGrade1Or2Kanji(''), isFalse);
    });
  });
}
