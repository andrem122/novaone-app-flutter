import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/screens/listCompanies/bloc/list_companies_bloc.dart';
import 'package:novaone/widgets/widgets.dart';

class ListCompaniesMobilePortrait extends StatefulWidget {
  const ListCompaniesMobilePortrait(
      {Key? key, required this.onCheckboxTap, required this.companyCount})
      : super(key: key);

  /// The local count of companies that is used to initialize _checked
  final int companyCount;

  /// The method that is called when the checkbox is tapped
  final Function(String? companyId) onCheckboxTap;

  @override
  State<ListCompaniesMobilePortrait> createState() =>
      _ListCompaniesMobilePortraitState();
}

class _ListCompaniesMobilePortraitState
    extends State<ListCompaniesMobilePortrait> {
  /// Keep a list of [bool] values to correspond to the checked state of each checkbox
  List<bool> _checked = [];

  /// Initialize class variables and constants
  void _initialize() {
    _checked = List.generate(widget.companyCount, (int index) => false);
  }

  @override
  initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListCompaniesBloc, ListCompaniesState>(
      builder: (BuildContext context, ListCompaniesState state) {
        if (state is ListCompaniesLoaded) {
          return _buildLoaded(context: context, state: state);
        }

        return _buildError(context: context);
      },
    );
  }

  Widget _buildLoaded(
      {required BuildContext context, required ListCompaniesLoaded state}) {
    return RoundedContainer(
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: state.tableItems.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
              title: Text(state.tableItems[index].title),
              value: _checked[index],
              onChanged: (bool? value) {
                setState(() {
                  /// Uncheck all other check boxes
                  _checked = List.generate(
                      state.tableItems.length, (int index) => false);
                  _checked[index] = value ?? false;
                });

                /// If the checkbox is checked, pass the company id to the
                /// [onCheckboxTap] method else pass null
                final bool checkboxValue = _checked[index];
                if (checkboxValue == true) {
                  try {
                    final company = state.tableItems[index].object as Company;
                    widget.onCheckboxTap('${company.id} ${company.name}');
                  } catch (error) {
                    print(
                        '_ListCompaniesMobilePortraitState._buildLoaded: $error');
                  }
                } else {
                  widget.onCheckboxTap(null);
                }
              });
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }

  Widget _buildError({required BuildContext context}) {
    return ErrorDisplay(
      onPressed: () {},
    );
  }
}
