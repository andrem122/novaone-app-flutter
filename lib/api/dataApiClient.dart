import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneUrl.dart';

/// A class that gets data for us about the user's account such as object counts and chart data
class DataApiClient extends BaseApiClient<ChartMonthlyData> {
  DataApiClient({required Client client, required ObjectStore userStore})
      : super(client: client, objectStore: userStore);

  /// Gets the chart data
  /// to the NovOne Api
  ///
  /// Returns an [ApiMessageException] object if the request fails
  /// and a list of [ChartMonthlyData] if the request was successful
  Future<List<ChartMonthlyData>> getMonthyChartData() async {
    // Need to get password seperatley because it is encrypted when
    // sent as data from the API
    final String password = await objectStore.getPassword();
    final User? user = await objectStore.getUser();

    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': password,
      'customerUserId': '${user?.customerId}',
    };

    final response = await postToNovaOneApi(
        uri: NovaOneUrl.novaOneApiChartMonthlyData,
        parameters: parameters,
        errorMessage: 'Could not fetch chart monthly data');

    final List<dynamic> jsonList = jsonDecode(response.body);
    final List<ChartMonthlyData> chartMonthlyData = jsonList
        .map((chartData) => ChartMonthlyData.fromJson(json: chartData))
        .toList();

    final now = DateTime.now();
    final startDate = DateTime(
        now.year - 1, now.month - 1, now.day, now.hour, now.minute, now.second);

    List<ChartMonthlyData> newChartMonthlyData = [];
    for (int monthCount = 0; monthCount < 12; monthCount++) {
      // Add 1 month to the start date on each loop iteration
      final nextMonth = startDate.month + monthCount + 1;
      final date = DateTime(startDate.year, nextMonth, startDate.day,
          startDate.hour, startDate.minute, startDate.second);
      final String month = DateFormat('MMM').format(date);

      /// Make the count zero if there is no count for the month
      final defaultChartData =
          ChartMonthlyData(month: month, year: date.year.toString(), count: 0);

      /// Try to find the month in the chart data
      /// If no month data is found, use the chart data above
      final ChartMonthlyData chartData = chartMonthlyData.firstWhere(
          (ChartMonthlyData chartData) => chartData.month == month,
          orElse: () => defaultChartData);

      newChartMonthlyData.add(chartData);
    }
    return newChartMonthlyData;
  }

  /// Gets the count of appointments, leads, and companies
  Future<List<ObjectCount>> getObjectCounts() async {
    final String password = await objectStore.getPassword();
    final User? user = await objectStore.getUser();

    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': password,
      'customerUserId': '${user?.customerId}',
    };

    final response = await postToNovaOneApi(
        uri: NovaOneUrl.novaOneApiObjectCountsData,
        parameters: parameters,
        errorMessage: 'Could not fetch object count data');

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => ObjectCount.fromJson(json: json)).toList();
  }
}
