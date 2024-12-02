// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

class Person {
  String name = "";
  int age = 0;

  // 默认构造函数
  Person(this.name, this.age);

  // 命名构造函数，用于创建一个未指定年龄的Person
  Person.withoutAge(this.name);

  // 方法，用于打印Person的信息
  void printInfo() {
    print('Name: $name, Age: $age');
  }
}

void main() {
  // 使用默认构造函数初始化
  Person person1 = Person('Alice', 30);
  person1.printInfo(); // 输出: Name: Alice, Age: 30

  // 使用命名构造函数初始化
  Person person2 = Person.withoutAge('Bob');
  person2.printInfo(); // 输出: Name: Bob, Age: null
}