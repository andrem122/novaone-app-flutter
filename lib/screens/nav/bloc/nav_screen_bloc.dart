import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneTableHelper.dart';
import 'package:novaone/screens/appointments/bloc/appointments_screen_bloc.dart';
import 'package:novaone/screens/companies/bloc/companies_screen_bloc.dart';
import 'package:novaone/screens/home/bloc/home_bloc.dart';
import 'package:novaone/screens/leads/bloc/leads_screen_bloc.dart';
import 'package:novaone/utils/urlLauncher.dart';
import 'package:novaone/widgets/widgets.dart';

part 'nav_screen_event.dart';
part 'nav_screen_state.dart';

class NavScreenBloc extends Bloc<NavScreenEvent, NavScreenState> {
  final LeadsApiClient leadsApiClient;
  final AppointmentsApiClient appointmentsApiClient;
  final CompaniesApiClient companiesApiClient;
  final HomeBloc homeBloc;
  final LeadsScreenBloc leadsScreenBloc;
  final AppointmentsScreenBloc appointmentsScreenBloc;
  final CompaniesScreenBloc companiesScreenBloc;
  final ObjectStore objectStore;

  NavScreenBloc({
    required this.leadsApiClient,
    required this.appointmentsApiClient,
    required this.companiesApiClient,
    required this.homeBloc,
    required this.leadsScreenBloc,
    required this.appointmentsScreenBloc,
    required this.companiesScreenBloc,
    required this.objectStore,
  }) : super(NavScreenInitial()) {
    on<NavScreenStart>(_start);
  }

  // Handles the startup of the navigation screen
  _start(NavScreenStart event, Emitter<NavScreenState> emit) async {
    /// Initialize objects to empty lists
    List<Lead> leads = [];
    List<Appointment> appointments = [];
    List<Company> companies = [];
    List<NovaOneListTableItemData> leadTableItems = [];
    List<NovaOneListTableItemData> appointmentTableItems = [];
    List<NovaOneListTableItemData> companyTableItems = [];

    try {
      try {
        await leadsApiClient.getRecentLeads();
        leads = await objectStore.getObjects<Lead>()
          ..sort((a, b) => b.id.compareTo(a.id));
      } catch (error) {
        print(
            'NavScreenBloc._start: An error occurred while fetching leads: $error');
      }

      try {
        await appointmentsApiClient.getRecentAppointments();
        appointments = await objectStore.getObjects<Appointment>()
          ..sort((a, b) => b.id.compareTo(a.id));
      } catch (error) {
        print(
            'NavScreenBloc._start: An error occurred while fetching appointments: $error');
      }

      try {
        await companiesApiClient.getRecentCompanies();
        companies = await objectStore.getObjects<Company>()
          ..sort((a, b) => b.id.compareTo(a.id));
      } catch (error) {
        print(
            'NavScreenBloc._start: An error occurred while fetching companies: $error');
      }

      /// Convert to the lists to [NovaOneListTableItemData]
      if (leads.isNotEmpty) {
        leadTableItems = leads
            .map((Lead lead) => NovaOneListTableItemData(
                popupMenuOptions: NovaOneTableHelper.instance
                    .listLeadTablePopupMenuOptions(onCallTap: () {
                  UrlLauncherHelper.instance.callNumber(lead);
                }, onEmailTap: () {
                  UrlLauncherHelper.instance.email(lead);
                }, onTextTap: () {
                  UrlLauncherHelper.instance.textNumber(lead);
                }),
                subtitle: DateFormat(NovaOneTable.defaultDateFormat)
                    .format(lead.dateOfInquiry),
                title: lead.name,
                id: lead.id,
                object: lead))
            .toList();
      }

      if (appointments.isNotEmpty) {
        appointmentTableItems = appointments
            .map((Appointment appointment) => NovaOneListTableItemData(
                popupMenuOptions: NovaOneTableHelper.instance
                    .listAppointmentTablePopupMenuOptions(onCallTap: () {
                  UrlLauncherHelper.instance.callNumber(appointment);
                }, onTextTap: () {
                  UrlLauncherHelper.instance.textNumber(appointment);
                }),
                subtitle: DateFormat(NovaOneTable.defaultDateFormat)
                    .format(appointment.time),
                title: appointment.name,
                id: appointment.id,
                object: appointment))
            .toList();
      }

      if (companies.isNotEmpty) {
        companyTableItems = companies
            .map((Company company) => NovaOneListTableItemData(
                popupMenuOptions:
                    NovaOneTableHelper.instance.companylistPopupMenuOptions,
                subtitle: DateFormat(NovaOneTable.defaultDateFormat)
                    .format(company.created),
                title: company.name,
                id: company.id,
                object: company))
            .toList();
      }

      homeBloc.add(
        HomeStart(
            recentAppointments: appointments.take(5).toList(),
            recentLeads: leads.take(5).toList(),
            companies: companies),
      );

      appointmentsScreenBloc.add(AppointmentsScreenLoadedFromNav(
          listTableItems: appointmentTableItems));
      leadsScreenBloc
          .add(LeadsScreenLoadedFromNav(listTableItems: leadTableItems));
      companiesScreenBloc
          .add(CompaniesScreenLoadedFromNav(listTableItems: companyTableItems));

      emit(NavScreenLoaded(companies));
    } catch (error, stackTrace) {
      print(stackTrace);
      emit(NavScreenError(error: error.toString(), stackTrace: stackTrace));
    }
  }
}
