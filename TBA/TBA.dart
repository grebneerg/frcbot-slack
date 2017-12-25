import "dart:convert";
import "dart:async";
import "package:http/http.dart" as http;

/// A wrapper for the The Blue Alliance API.
class TBA {
    String _key;
    Map<String, String> headers;

	// http.Client _client;
    
    final String baseUrl = "https://www.thebluealliance.com/api/v3";
    
	/// Creates a new TBA connection with the given access key.
    TBA(String this._key) {
        headers = {"X-TBA-Auth-Key": _key};
		// _client = new http.Client();
    }
    
	/// Returns a Map containing information about the team with number [number].
    Future<Map<String, String>> getTeam(int number) async {
        http.Response r = await http.get("${baseUrl}/team/frc${number}", headers: headers);
        return JSON.decode(r.body);
    }
}
