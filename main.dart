import './slack/Slack.dart';
import 'dart:async';
import 'dart:convert' show JSON, UTF8;
import 'dart:io';
import './TBA/TBA.dart';

TBA tba;
Slack sl;
String slVerificationToken;

HttpServer server;

Future main(List<String> args) async {
	int port;
	print(port);

	try {
		File vars = new File("./config.json");
		String v = await vars.readAsString();
		Map<String, dynamic> varMap = JSON.decode(v);
		initAPIs(varMap["TBA_KEY"], varMap["SLACK_KEY"], varMap["SLACK_VERIFICATION_TOKEN"]);
		if (varMap["PORT"] != null) port = varMap["PORT"];
	} catch (e) {
		initAPIs(Platform.environment["TBA_KEY"], Platform.environment["SLACK_KEY"], Platform.environment["SLACK_VERIFICATION_TOKEN"]);
	}

	
	try {
		port = int.parse(Platform.environment["PORT"]);
	} catch (e) {
		port ??= 8080;
	}

	server = await HttpServer.bind('0.0.0.0', port);

	await for (HttpRequest req in server) {
		handleRequest(req);
	}
}

void initAPIs(String tbaKey, String slackKey, String slackVerificationToken) {
	tba = new TBA(tbaKey);
	sl = new Slack(slackKey);
	slVerificationToken = slackVerificationToken;

	print("tba: $tbaKey, slack key $slackKey, verification: $slackVerificationToken");
}

void handleRequest(HttpRequest req) {
    if (req.method == "POST") {
        handlePost(req);
    } else if (req.method == "GET") {
        handleGet(req);
    } else {
        req.response
        	..statusCode = HttpStatus.METHOD_NOT_ALLOWED
        	..write("Unsupported request: ${req.method}.")
        	..close();
    }
}

void handleGet(HttpRequest req) {
    req.response
        ..statusCode = HttpStatus.OK
        ..write("wow you got it")
        ..close();
}

Future handlePost(HttpRequest req) async {
	ContentType ct = req.headers.contentType;
	Map<String, dynamic> json = new Map<String, dynamic>();
	if (ct != null && ct.mimeType == "application/json") {
		json = JSON.decode(await req.transform(UTF8.decoder).join());
	}
	switch (req.uri.path) {
		case "/slack/event":
			handleEvent(json, req);
			break;
		case "/slack/interaction":
			break;
	}
}

Future handleEvent(Map<String, dynamic> json, HttpRequest req) async {
	if (!json.containsKey("token") || json["token"] != slVerificationToken) {
		req.response
			..statusCode = HttpStatus.UNAUTHORIZED
			..write("Invalid verification token")
			..close();
	} else if (json.containsKey("challenge")) {
		req.response
			..statusCode = HttpStatus.OK
			..write(json["challenge"])
			..close();
	} else {
		req.response
			..statusCode = HttpStatus.OK
			..close();
		switch (json["event"]["type"]) {
			case "message":
				RegExp regex = new RegExp(r"team\s*(\d*)", caseSensitive: false);
				Iterable<Match> teams = regex.allMatches(json["event"]["text"]);
				List<Attachment> attachments = new List<Attachment>();
				if (teams.length > 0) {
					for (Match t in teams) {
						int tn = int.parse(t.group(1));
						attachments.add(await formatTeamInfo(tn));
					}
					sl.postMessage(json["event"]["channel"], new Message(attachments: attachments));
				}
				break;
		}
	}
}

Future<Attachment> formatTeamInfo(int teamNum) async{
	Map<String, dynamic> info = await tba.getTeam(teamNum);
	Attachment a;

	if (info.containsKey("Errors")) {
		a = new Attachment("No data for team $teamNum :(", text: "No data for team $teamNum :sob:", color: "#b21818");
	} else {
		String title = "Team ${info["team_number"]}: ${info["nickname"]}";

		String text = "";
		text += info["state_prov"] != "" ? "*Based in:* ${info["state_prov"]}\n" : "";
		text += info["motto"] != "" ? "*Motto:* ${info["motto"]}\n" : "";
		text += info["rookie_year"] != "" ? "*Rookie Year:* ${info["rookie_year"]}\n" : "";
		text += info["home_championship"].containsKey("2017") ? "*Home chamionship 2017:* ${info["home_championship"]["2017"]}\n" : "";
		text += info["home_championship"].containsKey("2018") ? "*Home chamionship 2018+:* ${info["home_championship"]["2018"]}\n" : "";
		text += "<https://www.thebluealliance.com/team/${info["team_number"]}|View more on The Blue Alliance>";

		a = new Attachment("$title\n$text", text: text, title: title, title_link: info["website"], color: "#b21818");
	}

	return a;
}
