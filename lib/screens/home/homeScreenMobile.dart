import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/controllers/controller.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/screens/home/bloc/home_bloc.dart';
import 'package:novaone/widgets/simpleBarChart.dart';
import 'package:novaone/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/palette.dart';

/// Builds a BarChartRodData for the BarChartGroupData
///
/// The [y] value represents the height of the bar on the y-axis of the graph
/// while the width of the bar can be set with [barWidth]
BarChartRodData _buildBarRod({required double y, required double barWidth}) {
  return BarChartRodData(
      y: y,
      borderRadius: BorderRadius.circular(4),
      width: barWidth,
      gradientFrom: Palette.gradientFrom,
      gradientTo: Palette.gradientTo,
      gradientColorStops: Palette.gradientColorStops,
      colors: Palette.gradientColors);
}

/// Builds a list of BarChartGroupData items for a BarChartData item
///
/// The number of x plots on the graph is represented by [groups].
/// If, for example, 12 x points are desired on the graph, then [groups]
/// would be set to 12. A y value for each group or x point on the graph
/// is supplied by [yValues], and a [barWidth] can be set for each bar on the
/// bar chart.
List<BarChartGroupData> _buildBarChartGroupData(
    {required int groups,
    required List<double> yValues,
    required double barWidth}) {
  return List.generate(
      groups,
      (int index) => BarChartGroupData(x: index, barRods: <BarChartRodData>[
            _buildBarRod(y: yValues[index], barWidth: barWidth)
          ]));
}

class HomeMobilePortrait extends StatelessWidget {
  final HomeLoaded state;
  const HomeMobilePortrait({Key? key, required this.state}) : super(key: key);

  /// Gets the titles/lables for the x-axis
  String _getTitles(double value) {
    final chartData = state.chartMonthlyData;
    switch (value.toInt()) {
      case 0:
        return chartData[0].month;
      case 1:
        return chartData[1].month;
      case 2:
        return chartData[2].month;
      case 3:
        return chartData[3].month;
      case 4:
        return chartData[4].month;
      case 5:
        return chartData[5].month;
      case 6:
        return chartData[6].month;
      case 7:
        return chartData[7].month;
      case 8:
        return chartData[8].month;
      case 9:
        return chartData[9].month;
      case 10:
        return chartData[10].month;
      case 11:
        return chartData[11].month;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final barWidth = (size.width - 200) / 12;
    final List<double> yValues = state.chartMonthlyData
        .map((chartData) => chartData.count.toDouble())
        .toList();
    final User user = context.read<User>();
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: GreetingContainer(
            user: user,
            containerDecimalHeight: 0.30,
          ),
        ),
        SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                top: false,
                child: TitleSeperator(
                  title: 'An Overview',
                ),
              ),
            )),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
              appVerticalSpacing, appHorizontalSpacing, 0),
          sliver: SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              bottom: false,
              child: InfoCards(
                companies: state.companies,
                companyCount: state.objectCounts[1].count,
                appointmentCount: state.objectCounts[0].count,
                leadCount: state.objectCounts[2].count,
              ),
            ),
          ),
        ),
        SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                child: TitleSeperator(
                  title: 'Leads Per Month',
                ),
              ),
            )),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
              appVerticalSpacing, appHorizontalSpacing, 0),
          sliver: SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              bottom: false,
              child: state.chartMonthlyData.isNotEmpty
                  ? SimpleBarChart(
                      barChartData: BarChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: SideTitles(
                                showTitles: false,
                                getTextStyles:
                                    (BuildContext context, double value) =>
                                        const TextStyle(
                                            color: Palette.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                margin: 20,
                                reservedSize: 14,
                                interval: 10),
                            topTitles: SideTitles(showTitles: false),
                            show: true,
                            bottomTitles: SideTitles(
                                showTitles: true,
                                getTextStyles:
                                    (BuildContext context, double value) =>
                                        const TextStyle(
                                            color: Palette.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                margin: 10,
                                getTitles: _getTitles),
                          ),
                          axisTitleData: FlAxisTitleData(
                              bottomTitle: AxisTitle(
                            titleText: 'Leads Per Month',
                            margin: 0,
                            showTitle: true,
                          )),
                          borderData: FlBorderData(show: false),
                          alignment: BarChartAlignment.spaceEvenly,
                          barGroups: _buildBarChartGroupData(
                              groups: 12,
                              yValues: yValues,
                              barWidth: barWidth)),
                    )
                  : EmptyDataBlock(
                      title: 'No Chart Data',
                      icon: Icon(
                        Icons.bar_chart,
                        size: 100,
                      ),
                    ),
            ),
          ),
        ),
        SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                child: TitleSeperator(
                  title: 'Recent Leads',
                  subtitle: 'View all',
                  showSubtitle: true,
                  onSubtitleTap: () =>
                      context.read<NavScreenController>().index = 2,
                ),
              ),
            )),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
              appVerticalSpacing, appHorizontalSpacing, 0),
          sliver: SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              bottom: false,
              child: state.recentLeads.isNotEmpty
                  ? RecentObjects(
                      objects: state.recentLeads.take(5).toList(),
                    )
                  : EmptyDataBlock(
                      title: 'No Leads',
                      icon: Icon(
                        Icons.group,
                        size: 100,
                      ),
                    ),
            ),
          ),
        ),
        SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                appHorizontalSpacing, 10, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                child: TitleSeperator(
                  title: 'Recent Appointments',
                  subtitle: 'View all',
                  showSubtitle: true,
                  onSubtitleTap: () =>
                      context.read<NavScreenController>().index = 1,
                ),
              ),
            )),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
              appVerticalSpacing, appHorizontalSpacing, 0),
          sliver: SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              bottom: false,
              child: state.recentAppointments.isNotEmpty
                  ? RecentObjects(
                      objects: state.recentAppointments.take(5).toList(),
                    )
                  : EmptyDataBlock(
                      title: 'No Appointments',
                      icon: Icon(
                        Icons.group,
                        size: 100,
                      ),
                    ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: const SizedBox(
            height: lastWidgetVerticalSpacing,
          ),
        ),
      ],
    );
  }
}

class HomeMobileLandscape extends StatelessWidget {
  final HomeLoaded state;
  const HomeMobileLandscape({Key? key, required this.state}) : super(key: key);

  /// Gets the titles/lables for the x-axis
  String _getTitles(double value) {
    final chartData = state.chartMonthlyData;
    switch (value.toInt()) {
      case 0:
        return chartData[0].month;
      case 1:
        return chartData[1].month;
      case 2:
        return chartData[2].month;
      case 3:
        return chartData[3].month;
      case 4:
        return chartData[4].month;
      case 5:
        return chartData[5].month;
      case 6:
        return chartData[6].month;
      case 7:
        return chartData[7].month;
      case 8:
        return chartData[8].month;
      case 9:
        return chartData[9].month;
      case 10:
        return chartData[10].month;
      case 11:
        return chartData[11].month;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final barWidth = (size.width - 200) / 12;
    final List<double> yValues = state.chartMonthlyData
        .map((chartData) => chartData.count.toDouble())
        .toList();
    final User user = context.read<User>();
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: GreetingContainer(
            user: user,
            containerDecimalHeight: 0.60,
          ),
        ),
        SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                child: TitleSeperator(
                  title: 'An Overview',
                ),
              ),
            )),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
              appVerticalSpacing, appHorizontalSpacing, 0),
          sliver: SliverToBoxAdapter(
            child: SafeArea(
              child: InfoCards(
                companies: state.companies,
                companyCount: state.objectCounts[1].count,
                appointmentCount: state.objectCounts[0].count,
                leadCount: state.objectCounts[2].count,
              ),
            ),
          ),
        ),
        SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                child: TitleSeperator(
                  title: 'Leads Per Month',
                ),
              ),
            )),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
              appVerticalSpacing, appHorizontalSpacing, 0),
          sliver: SliverToBoxAdapter(
            child: SafeArea(
              child: state.chartMonthlyData.isNotEmpty
                  ? SimpleBarChart(
                      barChartData: BarChartData(
                          titlesData: FlTitlesData(
                            leftTitles: SideTitles(
                                showTitles: true,
                                getTextStyles:
                                    (BuildContext context, double value) =>
                                        const TextStyle(
                                            color: Palette.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                margin: 20,
                                reservedSize: 14,
                                interval: 10),
                            show: true,
                            bottomTitles: SideTitles(
                                showTitles: true,
                                getTextStyles:
                                    (BuildContext context, double value) =>
                                        const TextStyle(
                                            color: Palette.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                margin: 10,
                                getTitles: _getTitles),
                          ),
                          axisTitleData: FlAxisTitleData(
                              bottomTitle: AxisTitle(
                            titleText: 'Leads Per Month',
                            margin: 0,
                            showTitle: true,
                          )),
                          borderData: FlBorderData(show: false),
                          alignment: BarChartAlignment.spaceEvenly,
                          barGroups: _buildBarChartGroupData(
                              groups: 12,
                              yValues: yValues,
                              barWidth: barWidth)),
                    )
                  : EmptyDataBlock(
                      title: 'No Chart Data',
                      icon: Icon(
                        Icons.bar_chart,
                        size: 100,
                      ),
                    ),
            ),
          ),
        ),
        SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                child: TitleSeperator(
                  title: 'Recent Leads',
                  subtitle: 'View all',
                  showSubtitle: true,
                  onSubtitleTap: () =>
                      context.read<NavScreenController>().index = 2,
                ),
              ),
            )),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
              appVerticalSpacing, appHorizontalSpacing, 0),
          sliver: SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              bottom: false,
              child: state.recentLeads.isNotEmpty
                  ? RecentObjects(
                      objects: state.recentLeads.take(5).toList(),
                    )
                  : EmptyDataBlock(
                      title: 'No Leads',
                      icon: Icon(
                        Icons.group,
                        size: 100,
                      ),
                    ),
            ),
          ),
        ),
        SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                child: TitleSeperator(
                  title: 'Recent Appointments',
                  subtitle: 'View all',
                  showSubtitle: true,
                  onSubtitleTap: () =>
                      context.read<NavScreenController>().index = 1,
                ),
              ),
            )),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
              appVerticalSpacing, appHorizontalSpacing, 0),
          sliver: SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              bottom: false,
              child: state.recentAppointments.isNotEmpty
                  ? RecentObjects(
                      objects: state.recentAppointments.take(5).toList(),
                    )
                  : EmptyDataBlock(
                      title: 'No Appointments',
                      icon: Icon(
                        Icons.group,
                        size: 100,
                      ),
                    ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: const SizedBox(
            height: lastWidgetVerticalSpacing,
          ),
        ),
      ],
    );
  }
}
