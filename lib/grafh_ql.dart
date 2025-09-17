import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final HttpLink httpLink = HttpLink(
    'https://countries.trevorblades.com/', // Public GraphQL API
  );

  final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CountriesScreen(),
      ),
    );
  }
}

class CountriesScreen extends StatelessWidget {
  const CountriesScreen({super.key});

  final String query = """
   query {
    countries {
      code
      name
      emoji
      awsRegion
      states {
        code
        name
      }
    }
  }
  """;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🌍 Countries - GraphQL Example")),
      body: Query(
        options: QueryOptions(document: gql(query)),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (result.hasException) {
            return Center(child: Text("Error: ${result.exception.toString()}"));
          }

          final countries = result.data?['countries'] ?? [];

          return ListView.builder(
  itemCount: countries.length,
  itemBuilder: (context, index) {
    final country = countries[index];
    final states = country['states'] as List;

    return ExpansionTile(
      leading: Text(country['emoji'], style: const TextStyle(fontSize: 24)),
      title: Text("${country['name']} (${country['code']})"),
      subtitle: Text("AWS Region: ${country['awsRegion'] ?? 'N/A'}"),
      children: states.map((s) {
        return ListTile(
          title: Text(s['name'] ?? 'Unknown'),
          subtitle: Text("Code: ${s['code']}"),
        );
      }).toList(),
    );
  },
);
        },
      ),
    );
  }
}
