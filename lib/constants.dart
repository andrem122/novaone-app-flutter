import 'package:flutter/material.dart';

/// The global scaffold key
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

const double defaultPadding = 10;
const double borderRadius = 12;
const double containerBorderRadius = 15;
const double maxContainerWidth = 600;
const double maxButtonWidth = 600;
const double minButtonWidth = 88;
const double minButtonHeight = 50;
const double backButtonSize = 30;

/// The padding in the vertical direction for the modal popup
const double modalPopupVerticalPadding = 30;

/// The max width for the container around the text widget for
/// a list or detail table item
const double tableItemTextMaxWidthMobile = 175;

/// Spacing from the edge of the screen
const double appHorizontalSpacing = 10;

/// General vertical spacing betweeen widgets on a screen
const double appVerticalSpacing = 15;

/// Vertical spacing from the bottom of the page after the last widget
const double lastWidgetVerticalSpacing = 50;

/// Settings page
const double spaceBetweenSettingsItems = 25;

/// Height and width of the circle avatar near a list table item
const double listTableItemCircleAvatarSize = 45;

/// Font size for the letter inside the circle avatar for list table items
const double listTableItemCircleAvatarFontSize = 16;

/// The size of the icons in the sliver app bar
const double sliverAppBarIconSize = 25;

/// Paths
// Images
final String imagesPath = 'assets/images';
final String logoImage = '$imagesPath/novaOneLogo.png';

/// Splash
final String splashImage = '$imagesPath/launch/novaOneLogoVertical.png';

/// Slider
final String sliderImageTexting = '$imagesPath/slider/texting.png';
final String sliderImageCalendar = '$imagesPath/slider/calendar.png';

/// The border style used for the [TextFormField]s
final OutlineInputBorder textFormFieldBorderStyle = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.grey),
  borderRadius: BorderRadius.all(
    Radius.circular(borderRadius),
  ),
);

final String alabama = 'AL';
final String alaska = 'AK';
final String arizona = 'AZ';
final String arkansas = 'AR';
final String california = 'CA';
final String colorado = 'CO';
final String connecticut = 'CT';
final String delaware = 'DE';
final String florida = 'FL';
final String georgia = 'GA';
final String hawaii = 'HI';
final String idaho = 'ID';
final String illinois = 'IL';
final String indiana = 'IN';
final String iowa = 'IA';
final String kansas = 'KS';
final String kentucky = 'KY';
final String louisiana = 'LA';
final String maine = 'ME';
final String maryland = 'MD';
final String massachusetts = 'MA';
final String michigan = 'MI';
final String minnesota = 'MN';
final String mississippi = 'MS';
final String missouri = 'MO';
final String montana = 'MT';
final String nebraska = 'NE';
final String nevada = 'NV';
final String newHampshire = 'NH';
final String newJersey = 'NJ';
final String newMexico = 'NM';
final String newYork = 'NY';
final String northCarolina = 'NC';
final String northDakota = 'ND';
final String ohio = 'OH';
final String oklahoma = 'OK';
final String oregon = 'OR';
final String pennsylvania = 'PA';
final String rhodeIsland = 'RI';
final String southCarolina = 'SC';
final String southDakota = 'SD';
final String tennessee = 'TN';
final String texas = 'TX';
final String utah = 'UT';
final String vermont = 'VT';
final String virginia = 'VA';
final String washington = 'WA';
final String westVirginia = 'WV';
final String wisconsin = 'WI';
final String wyoming = 'WY';

final Set<Map<String, String>> states = {
  {alabama: 'Alabama'},
  {alaska: 'Alaska'},
  {arizona: 'Arizona'},
  {arkansas: 'Arkansas'},
  {california: 'California'},
  {colorado: 'Colorado'},
  {connecticut: 'Connecticut'},
  {delaware: 'Delaware'},
  {florida: 'Florida'},
  {georgia: 'Georgia'},
  {hawaii: 'Hawaii'},
  {idaho: 'Idaho'},
  {illinois: 'Illinois'},
  {indiana: 'Indiana'},
  {iowa: 'Iowa'},
  {kansas: 'Kansas'},
  {kentucky: 'Kentucky'},
  {louisiana: 'Louisiana'},
  {maine: 'Maine'},
  {maryland: 'Maryland'},
  {massachusetts: 'Massachusetts'},
  {michigan: 'Michigan'},
  {minnesota: 'Minnesota'},
  {mississippi: 'Mississippi'},
  {missouri: 'Missouri'},
  {montana: 'Montana'},
  {nebraska: 'Nebraska'},
  {nevada: 'Nevada'},
  {newHampshire: 'New Hampshire'},
  {newJersey: 'New Jersey'},
  {newMexico: 'New Mexico'},
  {newYork: 'New York'},
  {northCarolina: 'North Carolina'},
  {northDakota: 'North Dakota'},
  {ohio: 'Ohio'},
  {oklahoma: 'Oklahoma'},
  {oregon: 'Oregon'},
  {pennsylvania: 'Pennsylvania'},
  {rhodeIsland: 'Rhode Island'},
  {southCarolina: 'South Carolina'},
  {southDakota: 'South Dakota'},
  {tennessee: 'Tennessee'},
  {texas: 'Texas'},
  {utah: 'Utah'},
  {vermont: 'Vermont'},
  {virginia: 'Virginia'},
  {washington: 'Washington'},
  {westVirginia: 'West Virginia'},
  {wisconsin: 'Wisconsin'},
  {wyoming: 'Wyoming'},
};
