import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

final greeting = StateProvider<String>((ref) => "Hello world");

class WeatherPageRiverpod extends ConsumerWidget {
  const WeatherPageRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final greet = ref.watch(greeting);

    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(greet),
            ElevatedButton(onPressed: () {
              ref.read(greeting.notifier).state = "Hi";
            }, child: Text("Change Text Button"))
          ],
        ),
      ),
    );
  }
}
