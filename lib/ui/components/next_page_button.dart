import 'package:flutter/material.dart';
import 'package:hn_state_example/core/i18n/strings.dart';

class NextPageButton extends StatelessWidget {
  final bool loading;
  final VoidCallback nextPage;

  const NextPageButton({
    Key key,
    @required this.loading,
    @required this.nextPage,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: loading
          ? const CircularProgressIndicator()
          : RaisedButton(
              child: Text(
                Strings.of(context).pages.news.nextPage,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: nextPage,
              color: Colors.blue,
            ),
    );
  }
}
