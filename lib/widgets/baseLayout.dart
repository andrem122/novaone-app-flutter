import 'package:flutter/material.dart';

abstract class BaseLayoutStateless<L, E, EM> extends StatelessWidget {
  const BaseLayoutStateless({Key? key}) : super(key: key);

  /// The method that builds the widget for the state that is emitted when the data is being fetched
  Widget buildLoading(BuildContext context);

  /// The method that builds the widget for the state that is emitted when all data has been fetched successfully
  Widget buildLoaded(BuildContext context, L state);

  /// The method that builds the widget for the state that is emitted when an error occurs
  Widget buildError(BuildContext context, E state);

  /// The method that builds the widget for the state that is emitted when there is no data
  ///
  /// This method is optional as it may not be needed in some cases
  Widget buildEmpty(BuildContext context, EM state) {
    return SizedBox.shrink();
  }
}

abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({Key? key}) : super(key: key);
}

/// The base state class for the [BaseStatefulWidget]
abstract class BaseLayoutState<T extends BaseStatefulWidget, L, E, EM>
    extends State<T> {
  /// The method that builds the widget for the state that is emitted when the data is being fetched
  Widget buildLoading(BuildContext context);

  /// The method that builds the widget for the state that is emitted when all data has been fetched successfully
  Widget buildLoaded(BuildContext context, L state);

  /// The method that builds the widget for the state that is emitted when an error occurs
  Widget buildError(BuildContext context, E state);

  /// The method that builds the widget for the state that is emitted when there is no data
  ///
  /// This method is optional as it may not be needed in some cases
  Widget buildEmpty(BuildContext context, EM state) {
    return SizedBox.shrink();
  }
}
