import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:novaone/api/leadsApiClient.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneUrl.dart';
import 'package:novaone/testData.dart';
import 'package:sqflite/sqlite_api.dart';

import 'leadsApiClientTest.mocks.dart';

class MockDatabase extends Mock implements Database {}

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client, ObjectStore])
void main() {
  setUpAll(() {
    // ↓ required to avoid HTTP error 400 mocked returns
    HttpOverrides.global = null;
  });
  group('getRecentLeads', () {
    test('Returns a list of leads if the http call completes successfully',
        () async {
      final mockClient = MockClient();
      final mockObjectStore = MockObjectStore();
      final leadsApiClient =
          LeadsApiClient(client: mockClient, objectStore: mockObjectStore);

      /// When the [ObjectStore.getUser] method is called on the mock object we created, return this response
      when(mockObjectStore.getUser()).thenAnswer(
        (_) => Future.value(
          User.fromJson(
            json: jsonDecode(jsonUser),
          ),
        ),
      );

      when(mockObjectStore.getPassword())
          .thenAnswer((_) => Future.value(testPassword));

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.

      when(leadsApiClient.postToNovaOneApi(
              testing: true,
              uri: NovaOneUrl.novaOneApiLeadsData,
              parameters: testGetParameters,
              errorMessage: 'Could not fetch lead data'))
          .thenAnswer((_) => Future.value(http.Response(jsonLeads, 200)));

      await leadsApiClient.getRecentLeads();

      /// Verify methods have been called
      verify(mockObjectStore.getUser());
      verify(mockObjectStore.getPassword());

      /// Check if we get a list of leads
      expect(await leadsApiClient.getRecentLeads(), isA<List<Lead>>());
    });

    // test('throws an exception if the http call completes with an error', () {
    //   final client = MockClient();

    //   // Use Mockito to return an unsuccessful response when it calls the
    //   // provided http.Client.
    //   when(client
    //           .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
    //       .thenAnswer((_) async => http.Response('Not Found', 404));

    //   expect(fetchAlbum(client), throwsException);
    // });
  });
}
