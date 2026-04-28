import 'package:flutter_test/flutter_test.dart';
import 'package:findkal/counter.dart';

void main() {
  test('Counter increments', () {
    final counter = Counter();
    expect(counter.counter, 0);
    counter.increment();
    expect(counter.counter, 1);
  });

  test('Counter decrements', () {
    final counter = Counter();
    expect(counter.counter, 0);
    counter.decrement();
    expect(counter.counter, -1);
  });
}